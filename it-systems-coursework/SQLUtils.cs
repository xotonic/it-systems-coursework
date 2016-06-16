using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Npgsql;
namespace it_systems_coursework
{
    public static class SQLUtils
    {
        private static string server="localhost", 
                              username="postgres", 
                              password="postgres", 
                              database="geekandgop";
        private static int port=5433;
        private static string connect_params
        { get { return string.Format("Host={0};Username={1};Password={2};Database={3};Port={4}",
           server, username, password, database, port); }
        }

        public static NpgsqlConnection CreateAndOpen()
        {
            var conn = new NpgsqlConnection(connect_params);
            conn.Open();
            
            return conn;
        }

        public static string userfirstname, usersecondname, userlogin, userpassword;
        public static bool useradmin;

        public static bool autorize()
        {
            return (bool) new Autorization().ShowDialog();
        }
    }
}
