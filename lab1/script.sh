
#!/bin/sh

mkdir test

find -a /etc >> /root/test/list

find /etc -type d | wc -l >> /root/test/list

find /etc -type f -name ".*" | wc -l >> /root/test/list

mkdir /root/test/links

ln /root/test/list /root/test/links/list_hlink
ln -s /root/test/list /root/test/links/list_slink

echo find -h /root/test/links/list_hlink | wc -l
echo find -h /root/test/list | wc -l
echo find -h /root/test/links/list_slink | wc -l

wc -l /root/test/list >> list_hlink

cmp -s /root/test/links/list_hlink /root/test/links/list_slink && echo "Yes"

mv /root/test/list /root/test/list1

cmp -s /root/test/links/list_hlink /root/test/links/list_slink && echo "Yes"

ln /root/test/list /root/list_hlink_in_root  

find /etc -type f -name "*.conf" >> /root/list_conf

find /etc -type d -name ".d" >> /root/list.d

cat /root/list_conf /root/list.d > /root/list_conf_d

tar -cf list_conf_d.tar list_conf_d

find /root/test

man --help >> /root/man.txt

split -b 1K /root/man.txt man_part.

mkdir /root/test/man.dir

mv /root/man_part* /root/test/man.dir

cat /root/test/man.dir/man_part* > /root/test/man.dir/man.txt

cmp -s /root/man.txt /root/test/man.dir/man.txt && echo "Yes"

echo "1st string\n 2nd string" > newfile
cat /root/man.txt >> newfile
mv newfile /root/man.txt

echo "1st string\n 2nd string" >> /root/man.txt

diff -u /root/man.txt /root/test/man.dir/man.txt >> dif

mv /root/dif /root/test/man.dir/dif

patch /root/test/man.dir/man.txt /root/test/man.dir/dif

cmp -s /root/man.txt /root/test/man.dir/man.txt && echo "Yes"

