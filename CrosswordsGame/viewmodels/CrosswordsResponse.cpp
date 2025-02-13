#include "CrosswordsResponse.h"

#include "data/UnitOfWork.h"
#include "repositories/CrosswordsResponseRepository.h"

#include <condition_variable>
#include <mutex>
#include <queue>
#include <thread>

namespace {
constexpr auto sleepTime { 500 };
constexpr auto waitForFinishedTime { 10 };
} // namespace

struct CrosswordsResponsePrivate {
    explicit CrosswordsResponsePrivate(CrosswordsResponse* p) noexcept
        : p_ptr(p)
    {
    }

    CrosswordsResponse* p_ptr;

    QString awake;
    QList<QString> responses { 15 * 15 };

    std::atomic_bool running { false };
    std::atomic_bool finished { false };
    std::queue<std::pair<int, QString>> queueResponses;

    std::mutex mutex;
    std::condition_variable waitCondition;

    std::mutex exitMutex;
    std::condition_variable exitWaitCondition;

    std::thread workerThread;

    void stop() noexcept;
    void waitForFinished() noexcept;
    void saveResponse() noexcept;
    void loadResponses(UnitOfWork& uow) noexcept;
};

void CrosswordsResponsePrivate::stop() noexcept
{
    {
        std::scoped_lock const lock { mutex };
        running.store(false);
    }
    waitCondition.notify_one();
}

void CrosswordsResponsePrivate::waitForFinished() noexcept
{
    std::unique_lock<std::mutex> lock { exitMutex };
    exitWaitCondition.wait(lock, [this] { return finished.load(); });
}

void CrosswordsResponsePrivate::saveResponse() noexcept
{
    while (running.load()) {
        std::queue<std::pair<int, QString>> queue;
        {
            std::unique_lock<std::mutex> lock { mutex };
            if (queueResponses.empty()) {
                waitCondition.wait_for(lock, std::chrono::milliseconds(sleepTime));
                continue;
            }

            std::swap(queue, queueResponses);
        }

        auto& uow = UnitOfWork::instance();
        uow.beginTransaction();

        bool success { false };
        while (queue.size() > 0) {
            auto [position, response] = queue.front();
            queue.pop();

            if (responses[position] == response) {
                continue;
            }

            success = uow.getCrosswordsResponseRepository().insertResponse(awake, position, response);
            if (!success) {
                break;
            }
            responses[position] = response;
        }

        if (success) {
            uow.commitTransaction();
            emit p_ptr->responsesChanged();
        } else {
            uow.rollbackTransaction();
        }
    }

    {
        std::unique_lock<std::mutex> lock { exitMutex };
        finished.store(true);
    }
    exitWaitCondition.notify_one();
}

void CrosswordsResponsePrivate::loadResponses(UnitOfWork& uow) noexcept
{
    responses = uow.getCrosswordsResponseRepository().getCrosswordsResponse(awake);
    emit p_ptr->responsesChanged();
}

CrosswordsResponse::CrosswordsResponse(QObject* parent) noexcept
    : QObject(parent)
    , d_ptr(std::make_unique<CrosswordsResponsePrivate>(this))
{
}

CrosswordsResponse::~CrosswordsResponse() noexcept
{
    d_ptr->stop();
    d_ptr->waitForFinished();
    qDebug() << __PRETTY_FUNCTION__;
}

void CrosswordsResponse::classBegin() noexcept { }

void CrosswordsResponse::componentComplete() noexcept
{
    auto& uow = UnitOfWork::instance();
    if (!uow.initialize()) {
        return;
    }

    d_ptr->loadResponses(uow);

    d_ptr->running.store(true);
    d_ptr->workerThread = std::thread(&CrosswordsResponsePrivate::saveResponse, d_ptr.get());
    d_ptr->workerThread.detach();
}

QString CrosswordsResponse::awake() const noexcept
{
    return d_ptr->awake;
}

void CrosswordsResponse::setAwake(const QString& value) noexcept
{
    if (d_ptr->awake == value) {
        return;
    }

    d_ptr->awake = value;
    emit awakeChanged();
}

QList<QString> CrosswordsResponse::responses() const
{
    return d_ptr->responses;
}

void CrosswordsResponse::save(int position, const QString& response) noexcept
{
    try {
        std::unique_lock<std::mutex> const lock { d_ptr->mutex };
        d_ptr->queueResponses.emplace(position, response);
    } catch (std::exception const& e) {
        qCritical() << e.what();
    }
}

void CrosswordsResponse::reset() noexcept
{
    auto& uow = UnitOfWork::instance();
    uow.beginTransaction();

    bool success = uow.getCrosswordsResponseRepository().deleteResponses(d_ptr->awake);
    if (success) {
        uow.commitTransaction();
    } else {
        uow.rollbackTransaction();
    }

    d_ptr->loadResponses(uow);
}
