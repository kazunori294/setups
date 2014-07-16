yum install -y python
yum install -y python-setuptools
easy_install pip
git clone https://github.com/vmware/pyvmomi.git
cd pyvmomi
python setup.py install

