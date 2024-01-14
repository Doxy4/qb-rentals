Config = {}

Config.PedLocation = vector4(-1016.83, -2696.91, 13.98, 149.17)
Config.VehicleLocation = vector4(-1018.98, -2701.22, 13.76, 60.52)

Config.Vehicles= {
        {
                title = "Euros",
                name = "euros",
                image = "https://cdn.discordapp.com/attachments/905103108382801961/1195858390522548284/image.png?ex=65b584ea&is=65a30fea&hm=cc930e0167d90347ff2e9a73e9bea3323bf0823ea4414776bf67a73232bc79de&",
                price = 150,
        },
        {
                title = "Vectre",
                name = "vectre",
                image = "https://cdn.discordapp.com/attachments/905103108382801961/1195858829808783491/image.png?ex=65b58553&is=65a31053&hm=933370240a7853cea8d17a97115cab46631a9fa3fc59e21904acdb2c632250da&",
                price = 125,
        },
        {
                title = "Rhinehart",
                name = "rhinehart",
                image = "https://cdn.discordapp.com/attachments/905103108382801961/1195859259162890280/image.png?ex=65b585b9&is=65a310b9&hm=f3e648e5e90afc4431dced39794db889a1850a72ceb46b4b79ab1c600a9d34f9&",
                price = 100,
        },
        {
                title = "Champion",
                name = "champion",
                image = "https://cdn.discordapp.com/attachments/905103108382801961/1195859817886134372/image.png?ex=65b5863e&is=65a3113e&hm=bfcff4285e5cfd40f107392ba085c10e218647e9fe062b248f22d54e8209a817&",
                price = 115,
        },
}

Config.Notify = {
        timeout = "The Rental Got Taken From You", "success",
        returned = "You Returned The Vehicle", "success",
        nomoney = "You Dont Have Enough Money", "error",
        tofar = "You Are To Far Away From The Rental Vehicle", "error",
        wrongvehicle = "This Is Not The Vehicle You Rented", "error",
        notrenting = "You Are Not Renting A Vehicle Yet", "error",
        alreadyrenting = "You Are Already Renting A Vehicle", "error",
        rented = "You Rented A Vehicle", "success",
}