Feature:Dummy

    Scenario: Dummy
        * def dataGenerator = Java.type('helpers.DataGenerator')
        * def randomEmail = 
            """
            function() { 
                var Generator = Java.type('helpers.DataGenerator');
                var instance = new Generator();
                return instance.getRandomEmail2();
            }
            """
        * def randomUserName = 
            """
            function() { 
                var Generator = Java.type('helpers.DataGenerator');
                var instance = new Generator();
                return instance.getRandomUsername2();
            }
            """
        * print randomEmail()
        * print randomUserName()
