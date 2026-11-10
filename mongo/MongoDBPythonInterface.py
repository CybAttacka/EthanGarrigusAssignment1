from pymongo import MongoClient
import ast

client = MongoClient("mongodb://localhost:27017/")

db = client["LibraryDatabaseAssignment2"]


while True:
    print(" ")
    print("=======================================")
    print("Python-Mongo Integration Interface Menu")
    print("=======================================")
    print("1: Find specific documents in a collection.")
    print("2: Count the documents in a collection.")
    print("3: Print the distinct values for a parameter in a collection.")
    print("4: Delete specific documents in a collection.")
    print("5: Update documents in a collection.")
    print("6: Insert a new document into a collection.")
    print("99: Stop program")
    print("Available collections are:")
    print("PATRON, PATRONTYPE, NOTIFICATIONPREFERENCE, PATRONACTIVITY, HOMELIBRARY")
    integer_choice = input("\nEnter choice as an integer input: ")
    #1 - Find specific documents
    if integer_choice == "1":
        desired_collection = input("\nEnter desired collection: ")
        desired_query = input("\nEnter desired query: ")

        try:
            results = db[desired_collection].find(ast.literal_eval(desired_query))
            print(db[desired_collection].count_documents(ast.literal_eval(desired_query)), "document(s) were found matching this query.")
            for line in results:
                print(line)

        except Exception as e:
            print("Error:", e)
    #2 - Count documents
    if integer_choice == "2":
        desired_collection = input("\nEnter desired collection: ")

        try:
            results = db[desired_collection].count_documents({})

            print(results, "document(s) were found.")

        except Exception as e:
            print("Error:", e)
    #3 - Print all distinct values
    if integer_choice == "3":
        desired_collection = input("\nEnter desired collection: ")
        desired_parameter = input("\nEnter desired parameter to check for uniqueness (such as \"AgeRange\" for PATRON): ")
        try:
            results = db[desired_collection].distinct(desired_parameter)

            for document in results:
                print(document)

        except Exception as e:
            print("Error:", e)

    if integer_choice == "99":
        break

    #4 - Delete documents
    if integer_choice == "4":
        desired_collection = input("\nEnter desired collection: ")
        desired_query = input("\nEnter query to identify desired document to delete: ")

        try:
            result = db[desired_collection].delete_many(ast.literal_eval(desired_query))

            print(result.deleted_count, "document(s) deleted.")

        except Exception as e:
            print("Error:", e)
    #5 - Update documents
    if integer_choice == "5":
        desired_collection = input("\nEnter desired collection: ")
        desired_query = input("\nEnter query to identify desired document(s) to update: ")
        desired_update = input("\nEnter desired update: ")

        try:
            result = db[desired_collection].update_many(ast.literal_eval(desired_query), ast.literal_eval(desired_update))
            print(result.modified_count, "document(s) updated.")

        except Exception as e:
            print("Error:", e)
    #6 - Insert one new document
    if integer_choice == "6":
        desired_collection = input("\nEnter desired collection: ")
        desired_document = input("\nEnter document to insert: ")

        try:
            result = db[desired_collection].insert_one(ast.literal_eval(desired_document))
            print("The document has been successfully added.")

        except Exception as e:
            print("Error:", e)




client.close()
print("Client has been closed.")