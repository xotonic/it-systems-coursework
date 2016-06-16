using Npgsql;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace it_systems_coursework
{
    /// <summary>
    /// Логика взаимодействия для AddOrder.xaml
    /// </summary>
    public partial class AddOrder : Window
    {
        public Order order
        {
            set
            {
                pc = value;
            }
            get
            {
                return pc; ;
            }
        }

        private Order pc;
        private bool update;
        public AddOrder()
        {
            InitializeComponent();
            pc = new Order() { customer = "-", address = "-"};
        }
       /* public AddOrder(Order ord)
        {
            InitializeComponent();
            pc = ord;
            customer.Text = ord.customer;
            address.Text = ord.address;
            update = true;
            Ok.Content = "Изменить";
        }
        */
        private void Accept(object sender, RoutedEventArgs e)
        {
            pc.customer = customer.Text;
            pc.address = address.Text;

            using (var conn = SQLUtils.CreateAndOpen())
            {
                using (var cmd = new NpgsqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandText = string.Format("select add_order('{0}', '{1}', '{2}', '{3}')", 
                        pc.customer, pc.address, SQLUtils.userlogin, SQLUtils.userpassword);
                    if (cmd.ExecuteNonQuery() == 0)
                        MessageBox.Show("Не удалось создать запись. Обратитесь к администаратору.");
                }
            }

            DialogResult = true;
        }
    }
}
