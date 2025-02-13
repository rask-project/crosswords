#include "CrosswordsModel.h"

#include "Crosswords.h"
#include "data/UnitOfWork.h"
#include "repositories/CrosswordsRepository.h"

#include <QDebug>
#include <QJsonDocument>

CrosswordsModel::CrosswordsModel(QObject* parent) noexcept
    : QObject(parent)
{
    UnitOfWork& uow = UnitOfWork::instance();
    uow.beginTransaction();
    if (!uow.initialize()) {
        uow.rollbackTransaction();
        qCritical() << "Failed to initialize UnitOfWork";
        return;
    }
    uow.commitTransaction();

    m_crosswords = uow.getCrosswordsRepository().getAllCrosswords(this);
    if (m_crosswords.isEmpty()) {
        qCritical() << "Failed to get all crosswords";
        return;
    }

    emit modelChanged();
}

CrosswordsModel::~CrosswordsModel() noexcept = default;

QList<Crosswords*> CrosswordsModel::model() const
{
    return m_crosswords;
}
