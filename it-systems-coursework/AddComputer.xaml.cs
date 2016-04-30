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
    public partial class AddComputer : Window
    {
        public Computer computer
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

        private Computer pc;
        private bool update;
        public AddComputer()
        {
            InitializeComponent();
            pc = new Computer() { name = "-", producer = "-", count = 0 };
        }
        public AddComputer(Computer comp)
        {
            InitializeComponent();
            pc = comp;
            name.Text = comp.name;
            producer.Text = comp.producer;
            count.Text = comp.count.ToString();
        }

        private void Accept(object sender, RoutedEventArgs e)
        {
            pc.name     = name.Text;
            pc.producer = producer.Text;
            pc.count    = uint.Parse(count.Text);

            DialogResult = true;
        }
    }
}
