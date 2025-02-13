#pragma once

#include <QColor>
#include <QObject>
#include <QQmlEngine>

class Android : public QObject {
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
public:
    explicit Android(QObject* parent = nullptr);

    Q_INVOKABLE static void setStatusBarColor(const QColor& color);
    Q_INVOKABLE static void setNavigationBarColor(const QColor& color);
    Q_INVOKABLE static void hideSplashScreen(int delay = 0);
};
