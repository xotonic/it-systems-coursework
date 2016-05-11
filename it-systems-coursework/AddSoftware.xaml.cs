using System;
using System.Collections.Generic;
using System.Diagnostics;
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
    public partial class AddSoftware : Window
    {
        public Software software
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

        private Software pc;
        private bool update;
        public AddSoftware()
        {
            InitializeComponent();
            pc = new Software() { name = "-", producer = "-", price = 0 };
        }
        public AddSoftware(Software comp)
        {
            InitializeComponent();
            pc = comp;
            name.Text = comp.name;
            producer.Text = comp.producer;
            price.Text = comp.price.ToString();
        }

        private void Accept(object sender, RoutedEventArgs e)
        {
            pc.name     = name.Text;
            pc.producer = producer.Text;
            pc.price    = float.Parse(price.Text);

            DialogResult = true;
        }
    }
}
