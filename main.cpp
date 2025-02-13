#include <QGuiApplication>
#include <QIcon>
#include <QQmlApplicationEngine>

int main(int argc, char* argv[])
{
    QCoreApplication::setOrganizationDomain(QStringLiteral("com.github.rask-project"));
    QCoreApplication::setApplicationName(QStringLiteral("BiblicalCrosswords"));
    QCoreApplication::setApplicationVersion(QStringLiteral("1.0.0"));

    QGuiApplication app(argc, argv);
    QLocale::setDefault(QLocale::system());

    QQmlApplicationEngine engine;

    QIcon::setThemeSearchPaths({ ":/icons" });
    QIcon::setThemeName(QStringLiteral("material-round"));

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("Game", "Main");

    return QGuiApplication::exec();
}
