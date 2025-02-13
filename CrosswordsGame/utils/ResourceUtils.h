#pragma once

class QString;

class ResourceUtils {
public:
    static QString readResource(const QString& name) noexcept;
};
