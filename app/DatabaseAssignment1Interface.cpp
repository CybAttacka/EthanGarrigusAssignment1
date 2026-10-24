//Using MySQL Connector C++ 26.10 ZIP file. Microsoft configurated to Release x64.
//Github link:  https://github.com/CybAttacka/EthanGarrigusAssignment1
#include <mysqlx/xdevapi.h>  
#include <iostream>  
#include <string>
using namespace std;
using namespace mysqlx;  
int InputInt()
{
    int user_int;
    while (!(cin >> user_int))
    {
        cout << "Invalid input. Enter an integer: ";
        cin.clear();
        cin.ignore(numeric_limits<streamsize>::max(), '\n');
    }

    return user_int;
}
int main() {
    try { 
        Session session("localhost", 33060, "root", "Zrg0Bksis&sseven", "library_assignment_1_take2");

        cout << "Connected to MySQL successfully!" << endl;
 
        int menu_choice = 0;
        while (menu_choice != 3)
        {
            cout << endl << "=======================" << endl;
            cout << "Database Interaction Menu" << endl;
            cout << "=======================" << endl;
            cout << "1: Query the database." << endl;
            cout << "2: Update or delete from the database." << endl;
            cout << "3: Stop the program." << endl;
            cout << "Tables are: PATRON, PATRONTYPE, PATRONACTIVITY, HOMELIBRARY, NOTIFICATIONPREFERENCE" << endl;
            cout <<endl<< "Enter an integer according to your choice: ";
            menu_choice = InputInt();
            cout << endl;

            if (menu_choice == 1) //Basic Query - Prints out requested lines
            {
                cin.ignore(numeric_limits<streamsize>::max(), '\n'); //Ignores any leftover input
                std::string user_query;//Makes a string and gets user input
                cout << "Enter SQL query: ";
                getline(cin, user_query);
                try
                {
                    SqlResult query_result = session.sql(user_query).execute();
                    for (int i = 0; i < query_result.getColumnCount(); i++) //Displays the name of each column
                    {
                        cout << query_result.getColumn(i).getColumnName() << "\t";
                    }
                    cout << endl;
                    Row query_row; //Displays each row
                    while ((query_row = query_result.fetchOne()))
                    {
                        for (int i = 0; i < query_row.colCount(); i++)
                        {
                            if (query_row[i].isNull())
                                cout << "NULL";
                            else
                                cout << query_row[i];
                            cout << "\t";
                        }
                        cout << endl;
                    }
                    
                    cout << "Query executed successfully." << endl; //End of query section
                }
                catch (const Error& query_error)
                {
                    cerr << "Query Error: " << query_error.what() << endl;
                }
            }
            if (menu_choice == 2) //Update or delete from database
            {
                cin.ignore(numeric_limits<streamsize>::max(), '\n'); //Ignores leftover input
                std::string update_query;//Makes a string and gets user input
                cout << "Enter your SQL UPDATE statement:" << endl;
                getline(cin, update_query);
                try
                {
                    SqlResult result = session.sql(update_query).execute();//Executes statement if there is no error
                    cout << "Database updated successfully!" << endl;
                    cout << "Rows affected: " << result.getAffectedItemsCount() << endl;//Counts the number of affected rows
                }
                catch (const Error& e)
                {
                    cerr << "Update/Deletion Error: " << e.what() << endl;
                }
            }
        }

        session.close(); 
    }
    catch (const Error& connection_error) {
        cerr << "Connection Error: " << connection_error.what() << endl;
    }
}