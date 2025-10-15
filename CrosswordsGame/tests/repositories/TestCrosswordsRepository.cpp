#include <gtest/gtest.h>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QJsonDocument>
#include "CrosswordsGame/repositories/CrosswordsRepository.h"
#include "CrosswordsGame/viewmodels/Crosswords.h"

// Test fixture to manage the in-memory database
class CrosswordsRepositoryTest : public ::testing::Test {
protected:
    QSqlDatabase m_db;

    void SetUp() override {
        // Use a unique connection name for each test to ensure isolation
        const QString connectionName = QString("test_connection_%1").arg(qrand());
        m_db = QSqlDatabase::addDatabase("QSQLITE", connectionName);
        m_db.setDatabaseName(":memory:");

        ASSERT_TRUE(m_db.open()) << "Failed to open in-memory database";

        QSqlQuery query(m_db);

        // Create the schema for the 'crosswords' table
        ASSERT_TRUE(query.exec(
            "CREATE TABLE crosswords ("
            "    awake TEXT PRIMARY KEY NOT NULL,"
            "    label TEXT NOT NULL,"
            "    questions TEXT NOT NULL"
            ");"
        )) << qPrintable(query.lastError().text());
    }

    void TearDown() override {
        QString connectionName = m_db.connectionName();
        m_db.close();
        m_db = QSqlDatabase(); // Reset the object
        QSqlDatabase::removeDatabase(connectionName);
    }
};

// Test to verify if getAllCrosswords works with data inserted into the in-memory DB
TEST_F(CrosswordsRepositoryTest, GetAllCrosswords_ReturnsInsertedData) {
    // Arrange: Insert test data into the in-memory database
    QSqlQuery insertQuery(m_db);
    insertQuery.prepare("INSERT INTO crosswords (awake, label, questions) VALUES (?, ?, ?)");
    
    insertQuery.addBindValue("2023-01");
    insertQuery.addBindValue("Puzzle One");
    insertQuery.addBindValue("{\"key\":\"value\"}");
    ASSERT_TRUE(insertQuery.exec());

    insertQuery.addBindValue("2023-02");
    insertQuery.addBindValue("Puzzle Two");
    insertQuery.addBindValue("{\"key\":\"value2\"}");
    ASSERT_TRUE(insertQuery.exec());

    // Act: Call the method to be tested
    CrosswordsRepository repo(m_db);
    QList<Crosswords*> crosswordsList = repo.getAllCrosswords(nullptr);

    // Assert: Verify the results
    ASSERT_EQ(crosswordsList.size(), 2);
    
    // The order is DESC by 'awake', so the second inserted should be the first in the list
    EXPECT_EQ(crosswordsList[0]->label(), "Puzzle Two");
    EXPECT_EQ(crosswordsList[0]->awake(), "2023-02");
    EXPECT_EQ(crosswordsList[1]->label(), "Puzzle One");
    EXPECT_EQ(crosswordsList[1]->awake(), "2023-01");

    // Cleanup
    qDeleteAll(crosswordsList);
}

// Test for behavior when the table is empty
TEST_F(CrosswordsRepositoryTest, GetAllCrosswords_ReturnsEmptyListWhenNoData) {
    // Arrange: No data is inserted

    // Act
    CrosswordsRepository repo(m_db);
    QList<Crosswords*> crosswordsList = repo.getAllCrosswords(nullptr);

    // Assert
    ASSERT_EQ(crosswordsList.size(), 0);
}

