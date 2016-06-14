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
                return pc;
            }
        }

        private Computer pc;
        private bool update;
        public AddComputer()
        {
            InitializeComponent();
            pc = new Computer() { name = "-", producer = "-", price = 0 };
        }
        public AddComputer(Computer comp)
        {
            InitializeComponent();
            pc = comp;
            name.Text = comp.name;
            producer.Text = comp.producer;
            price.Text = comp.price.ToString();
            ram.Text = comp.ram.ToString();
            hdd.Text = comp.hdd.ToString();
            cores.Text = comp.cores.ToString();
            freq.Text = comp.freq.ToString();
            gpu.Text = comp.gpu.ToString();
            update = true;
            count.Visibility = Visibility.Collapsed;
            counttext.Visibility = Visibility.Collapsed;
            Ok.Content = "Изменить";
        }

        private void Accept(object sender, RoutedEventArgs e)
        {
            pc.name = name.Text;
            pc.producer = producer.Text;
            var cnt = 0;
            try
            {
                pc.price = float.Parse(price.Text);
                pc.ram = float.Parse(ram.Text);
                pc.hdd = float.Parse(hdd.Text);
                pc.cores = int.Parse(cores.Text);
                pc.freq = float.Parse(freq.Text);
                pc.gpu = float.Parse(gpu.Text);
                cnt = int.Parse(count.Text);
            }
            catch (FormatException) { MessageBox.Show("Не все поля заполнены, либо заполнены неправильно"); return; }

            if (update == true)
                pc.updateInDatabase();
            else
                pc.insertToDatabase(cnt);

            DialogResult = true;
        }
    }
}
