# day 4 - mongodb
1. ![image](https://github.com/user-attachments/assets/25abc7f7-4116-42bb-a165-d563a9878043)
2. each collection can contain many documents
3. JSON vs BSON  **[TODO]**
4. mongo db is a document database
5. key features:
- document based
- scalable
- flexible
- performant
- free and open source
- ![image](https://github.com/user-attachments/assets/659ec75f-028a-4040-b5dc-2f491e47b7c0)
6. ![image](https://github.com/user-attachments/assets/0a9edfc1-27f9-4f5c-8396-93281b734899)
![image](https://github.com/user-attachments/assets/52e1a191-9d4e-486a-858f-76292f015082)
7. typed -> means json structure includes the type that needs to be followed in BSON
  - json DOESNT CARE abt type of fields
8.![image](https://github.com/user-attachments/assets/ca6e5d54-ca83-4cbd-a1e8-dbf5edaafc6b)

![image](https://github.com/user-attachments/assets/3ecdde2d-559e-4af0-872f-907d510b7a0a)
9.
![image](https://github.com/user-attachments/assets/d180fbc9-2269-4867-8f97-7dc2aa4559a7)
- tours_test -> db
- tours -> collection
- {} -> document
10. find()
  ![image](https://github.com/user-attachments/assets/2caebbb3-f599-4474-8654-df5db3d81a4c)
11.show db
  ![image](https://github.com/user-attachments/assets/d2059679-d750-4e1e-b555-3e1a547d3c76)
12. change to another db:
  ![image](https://github.com/user-attachments/assets/cf26553f-d28a-4b05-bacb-a6e412c699d3)
13. show all collections
  14. insert Many
![image](https://github.com/user-attachments/assets/9cea47a9-00a5-49d1-b5f0-c924850ab9d7)
15.updateOne
  ![image](https://github.com/user-attachments/assets/9dd13011-1d7a-4f58-b9a4-f702efb1e8da)
- all documents will be updated with the same name
16. weird output:
  ![image](https://github.com/user-attachments/assets/1ba807de-845f-4ac3-aa11-a869f2fb254d)
17. updateMany
  ![image](https://github.com/user-attachments/assets/dff50582-99a5-4961-9a75-6d4fb84c3459)
18.refer these for more queries: https://www.mongodb.com/docs/manual/reference/operator/query/
19. deleteMany
![image](https://github.com/user-attachments/assets/a4af4d3b-eb31-4732-9706-11f193f41189)
20. access tos erver means access to entire database and NOT just a pert of a server like in sql
  so, we should be more careful on using this
  
