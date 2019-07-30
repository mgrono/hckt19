public with sharing class Reservation {

    private static Integer noOfContacts = 700;
    private static Integer noOfRooms = 20;
    private static Integer noOfReservations = 2400;
    private static Date startDate = Date.newInstance(2018, 10, 1);
    private static Date endDate = Date.newInstance(2018, 12, 31);
    /** Method allows to create default Account **/
    private static void createAccount(){
        Account account = new Account(Name = 'Reservation Account');
        insert account;
    }

    /** Method allows to create list of Contact objects with size = 500 **/
    private static void createContacts(){
        Account account = [ SELECT Id, Name FROM Account WHERE Name = 'Reservation Account' LIMIT 1 ];
        List<Contact> contacts = new List<Contact>();
        Integer iterator = 0;
        while(iterator < noOfContacts){
            Contact contact = new Contact(
                    AccountId = account.id,
                    FirstName = getRandonName(),
                    LastName = getRandomString(1, true) + getRandomString(4+getRandomNumber(10), false),
                    Entertainment__c = Reservation.generateRandomPicklist(Contact.fields.Entertainment__c.getDescribe().getpicklistvalues(), true),
                    Movies__c   = Reservation.generateRandomPicklist(Contact.fields.Movies__c.getDescribe().getpicklistvalues(), true),
                    Sport__c    = Reservation.generateRandomPicklist(Contact.fields.Sport__c.getDescribe().getpicklistvalues(), true), 
                    Shopping__c = Reservation.generateRandomPicklist(Contact.fields.Shopping__c.getDescribe().getpicklistvalues(), true), 
                    Hobbies_and_activities__c = Reservation.generateRandomPicklist(Contact.fields.Hobbies_and_activities__c.getDescribe().getpicklistvalues(), true), 
                    Food__c = Reservation.generateRandomPicklist(Contact.fields.Food__c.getDescribe().getpicklistvalues(), true),
                    Type__c = Reservation.generateRandomPicklist(Contact.fields.Type__c.getDescribe().getpicklistvalues(), false)
            );
            contacts.add(contact);
            iterator++;
        }
        insert contacts;
    }

    /** Method allows to crete list of Hotel objects with size = 4 **/
    private static void createHotels(){
        List<Hotel__c> l = new List<Hotel__c>{new Hotel__c(Name = 'TsmarT Boston Grove', 
                               Geo__latitude__s = 42.360418, 
                               Geo__longitude__s =  -71.068824, 
                               Address__c = '17 Grove Street, Boston, MA 02114-3203, United States of America'),
                               new Hotel__c(Name = 'TsmarT Boston Telegraph Hill', 
                               Geo__latitude__s = 42.333828 , 
                               Geo__longitude__s = -71.039819, 
                               Address__c = '517 East Fifth Street, Boston, MA 02127, United States of America'),
                               new Hotel__c(Name = 'TsmarT Boston Kendall', 
                               Geo__latitude__s = 42.366688, 
                               Geo__longitude__s = -71.084054, 
                               Address__c = '196 Rogers Street, Cambridge, MA 02142, United States of America'),
                               new Hotel__c(Name = 'TsmarT Boston East', 
                               Geo__latitude__s = 42.371419, 
                               Geo__longitude__s =  -71.162084, 
                               Address__c = '21 Hillside Road, Watertown, MA 02478-3432, United States of America')};
        insert l;              
    }

    /** Method allows to create list of Room object **/
    private static void createRooms(){
        List<String> roomType = new List<String>{'Single','Double','Apartment','VIP'};
        List<String> roomBedType = new List<String>{'Single','Queen','King'};
        List<Hotel__c> hotels = [ SELECT Name FROM Hotel__c ];
        List<Room__c> roomList = new List<Room__c>();
        for(Integer k = 0; k < hotels.size(); k++) {
            Integer i;
            i = 0;
            while (i < noOfRooms) {
                Integer roomTypeIndex = getRandomNumber(roomType.size());
                Integer roomBedTypeIndex = getRandomNumber(roomBedType.size());
                Room__c room = new Room__c(
                        Hotel__c = hotels[k].id,
                        ExternalId__c = k + String.valueOf(i + 1),
                        Floor__c = String.valueOf(getRandomNumber(8) + 1),
                        Bed_type__c = roomBedType.get(roomBedTypeIndex),
                        Type__c = roomType.get(roomTypeIndex)
                );
                roomList.add(room);
                i++;
            }
        }
        insert roomList;
    }


    /** Method allows to prepare data (contacts/hotels/rooms/reservations) **/
    @future
    public static void  prepareData(){
        deleteData();
        // insert account
        createAccount();
        // insert contacts
        createContacts();
        // insert hotels
        createHotels();
        // insert rooms
        createRooms();
        // create reservations
        addReservation();
    }
    /** Delete all objects to be able to start from scratch */
    public static void deleteData(){
        List<Account> accounts = [Select Id From Account];
        delete accounts;

        List<Contact> contacts = [Select Id From Contact];
        delete contacts;

        List<Reservation__c> reservations = [Select Id From Reservation__c];
        delete reservations;

        List<Room__c> rooms = [Select Id From Room__c];
        delete rooms;

        List<Hotel__c> hotels = [Select Id From Hotel__c];
        delete hotels;


    }
    private static void addReserations2() {
        Date checkInDate = randomDate(startDate, endDate);
    }

    /** Method allows to create reservations **/
    private static void addReservation(){
        List<Room__c> rooms = fetchRooms();
        List<Contact> contacts = fetchContacts();
        List<Reservation__c> reservations = new List<Reservation__c>();
        Integer iterator = 0;
        while(iterator < noOfReservations){

            // get random contact
            Integer randomIndex = (Math.random() * (contacts.size() - 1)).intValue();
            Contact contact = contacts.get(randomIndex);

            // get random date
            Date checkInDate = randomDate(startDate, endDate);
            Datetime checkInDateTime = checkInDate;
            String dayOfWeek = checkInDateTime.format('EEEE');
            Integer addDays = getRandomNumber(14) + 1;
            //long reservations
            if (addDays > 7 && (getRandomNumber(2) == 0 ? True : False) ) addDays = getRandomNumber(7) + 1;
            if (addDays > 7 && (getRandomNumber(2) == 0 ? True : False) ) addDays = getRandomNumber(7) + 1;
            //weekend
            if (dayOfWeek == 'Friday' && (getRandomNumber(2) == 0 ? True : False)) addDays = 2;
            //Xmas
            Date xMas_start = Date.newInstance(2018, 12, 21);
            Date xMas_end = Date.newInstance(2018, 12, 24);
            if (checkInDate >= xMas_start &&  checkInDate <= xMas_end) addDays = getRandomNumber(3) + 5;
            // get random room
            Date checkOutDate = checkInDate.addDays(addDays);

            randomIndex = (Math.random() * (rooms.size() - 1)).intValue();
            Room__c room = rooms.get(randomIndex);

             Reservation__c res = new Reservation__c(
                            Contact__c = contact.id,
                            Room__c = room.id,
                            DateCheckIn__c = checkInDate,
                            DateCheckOut__c = checkOutDate);

            // if reservation list is empty - add new reservation with random room
            if(reservations.isEmpty()) {
                reservations.add(res);
            }
            else
            {
                // get all reservations that contain a random room
                List<Reservation__c> reservationsContainRoom = new List<Reservation__c>();
                for(Reservation__c reservation : reservations){
                    if(room.id == reservation.Room__c){
                        reservationsContainRoom.add(reservation);
                    }
                }
                // if reservation list does not contain random room then add new reservation with random room
                if(reservationsContainRoom.isEmpty()){
                    reservations.add(res);

                // case: reservation list contains reservation with random room
                }
                else
                {
                    Boolean dataAvailable = True; 
                    for(Reservation__c rcr : reservationsContainRoom){
                        
                        dataAvailable = compareDate(rcr, checkInDate, checkOutDate);
                        if (dataAvailable == false) break;
                        // if random room is available then create new reservation with random room and break loop  
                    }
                    if(dataAvailable == True) {
                            reservations.add(res);
                        }
                }
            }
            iterator++;
        }
        insert reservations;
    }

    /** Method allows to compare dates **/
    private static Boolean compareDate(Reservation__c reservation,Date checkIn,Date checkOut){

        if((checkIn >= reservation.DateCheckIn__c && checkIn < reservation.DateCheckOut__c) ||
            (checkOut > reservation.DateCheckIn__c && checkOut <= reservation.DateCheckOut__c) ||
            (checkIn <= reservation.DateCheckIn__c && checkOut >= reservation.DateCheckOut__c)) {
            return false;
        }
        return true;
    }

    /** Method allows to get random date **/
    private static Date randomDate(Date minDate, Date maxDate){
        Integer rangeSize = minDate.daysBetween(maxDate) + 1;
        Decimal daysToAdd = rangeSize * math.Random();
        Date result = minDate.addDays(daysToAdd.intValue());
        return result;
    }

    /** Method allows to fetch list of contacts with size = 500 **/
    private static List<Contact> fetchContacts() {
        return [
                SELECT Id,Name FROM Contact LIMIT 500
        ];
    }

    /** Method allow to fetch list of rooms **/
    private static List<Room__c> fetchRooms() {
        return [
                SELECT Bed_type__c,Floor__c,Hotel__c,Type__c
                FROM Room__c
                LIMIT 10000
        ];
    }

    /** Method allows to get random number with specific size **/
    private static Integer getRandomNumber(Integer size) {
        Double d = math.random() * size;
        return d.intValue();
    }

    private static String getRandomString(Integer len ,Boolean capital) {
        String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
        if (capital == true) chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        String randStr = '';
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        return randStr; 
    }

    /**generate randomname */
    private static String getRandonName(){
        List<String> l = new List<String>{'Ofelia', 'Ahtahkakoop', 'Rajmund', 'Italo', 'Magda', 'Manlio', 'Panfilo', 'Ignacy', 'Kryspin', 'Paolina', 'Wincenty', 'Katia', 'Floro', 'Aureliana'};
        return l[getRandomNumber(l.size())];
    }
    /** gererate random values for multipicklist */
    public static String generateRandomPicklist(List<Schema.PicklistEntry> l, Boolean multi) {
       
        Integer hoops = getRandomNumber(l.size()/2);
        hoops = (hoops == 0 ? 1 : hoops) ;
         
        String values = ''; 
        for (Integer i = 0; i < hoops; i++) {
            values += l[getRandomNumber(l.size())].getLabel();
            if (multi == false)
                break;
            if (i+1 != hoops) 
                values += ';';
        } 
        return values;
    }
}