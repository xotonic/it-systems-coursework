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
            pc = new Order() { customer = "-", address = "-", count_soft = 0, count_hard = 0 };
        }
        public AddOrder(Order ord)
        {
            InitializeComponent();
            pc = ord;
            customer.Text = ord.customer;
            address.Text = ord.address;
            count_soft.Text = ord.count_soft.ToString();
            count_hard.Text = ord.count_hard.ToString();
            update = true;
            Ok.Content = "Изменить";
        }

        private void Accept(object sender, RoutedEventArgs e)
        {
            pc.customer = customer.Text;
            pc.address = address.Text;
            pc.count_soft = int.Parse(count_soft.Text);
            pc.count_hard = int.Parse(count_hard.Text);

            DialogResult = true;
        }
    }
}
