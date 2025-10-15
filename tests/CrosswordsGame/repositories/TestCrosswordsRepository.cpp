#include <gtest/gtest.h>
#include <gmock/gmock.h>
#include "CrosswordsGame/repositories/CrosswordsRepository.h"
#include "CrosswordsGame/viewmodels/Crosswords.h"
#include "CrosswordsGame/utils/ResourceUtils.h"

// Mock para QSqlDatabase (simplificado para demonstração)
class MockQSqlDatabase : public QSqlDatabase {
public:
    MOCK_METHOD(bool, isOpen, (), (const, override));
    MOCK_METHOD(bool, open, (), (override));
    MOCK_METHOD(void, close, (), (override));
    MOCK_METHOD(QSqlQuery, exec, (const QString& query), (override));
    // Mockar outros métodos conforme necessário
};

// Mock para QSqlQuery (simplificado para demonstração)
class MockQSqlQuery : public QSqlQuery {
public:
    MOCK_METHOD(bool, exec, (const QString& query), (override));
    MOCK_METHOD(bool, next, (), (override));
    MOCK_METHOD(QVariant, value, (int index), (const, override));
    MOCK_METHOD(QVariant, value, (const QString& name), (const, override));
    MOCK_METHOD(QSqlError, lastError, (), (const, override));
};

// Mock para ResourceUtils (para controlar o conteúdo do SQL)
class MockResourceUtils {
public:
    MOCK_STATIC_METHOD(QString, readResource, (const QString& path));
};

// Configurar o mock para ResourceUtils
namespace ResourceUtils {
    QString readResource(const QString& path) {
        return MockResourceUtils::readResource(path);
    }
}

TEST(CrosswordsRepositoryTest, GetAllCrosswordsReturnsCorrectData)
{
    MockQSqlDatabase mockDb;
    MockQSqlQuery mockQuery;

    // Configurar o mock para ResourceUtils para retornar o SQL esperado
    EXPECT_CALL(MockResourceUtils::getMock(), readResource(":/resources/sql/select_all_crosswords.sql"))
        .WillOnce(Return("SELECT awake, label, questions FROM crosswords ORDER BY awake DESC;"));

    // Configurar o mock para QSqlDatabase para retornar a mockQuery
    EXPECT_CALL(mockDb, exec(testing::An<const QString&>()))
        .WillOnce(Return(mockQuery));

    // Configurar o mock para QSqlQuery
    // Simular uma linha de resultado
    EXPECT_CALL(mockQuery, exec(testing::An<const QString&>()))
        .WillOnce(Return(true)); // Execução da query bem-sucedida
    EXPECT_CALL(mockQuery, next())
        .WillOnce(Return(true))  // Primeira linha existe
        .WillOnce(Return(false)); // Nenhuma outra linha
    EXPECT_CALL(mockQuery, value("awake"))
        .WillOnce(Return(QVariant("Awake1")));
    EXPECT_CALL(mockQuery, value("label"))
        .WillOnce(Return(QVariant("Puzzle1")));
    EXPECT_CALL(mockQuery, value("questions"))
        .WillOnce(Return(QVariant("{\"across\":{}, \"down\":{}}"))); // JSON vazio para simplificar

    CrosswordsRepository repo(mockDb);
    QList<Crosswords*> crosswordsList = repo.getAllCrosswords();

    ASSERT_EQ(crosswordsList.size(), 1);
    EXPECT_EQ(crosswordsList.first()->awake(), "Awake1");
    EXPECT_EQ(crosswordsList.first()->label(), "Puzzle1");

    // Limpeza
    qDeleteAll(crosswordsList);
}

// Outros testes para cenários de erro, etc.

