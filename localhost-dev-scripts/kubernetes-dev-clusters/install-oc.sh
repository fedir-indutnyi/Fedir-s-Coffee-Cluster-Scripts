wget https://github.com/openshift/okd/releases/download/4.5.0-0.okd-2020-07-14-153706-ga/openshift-client-linux-4.5.0-0.okd-2020-07-14-153706-ga.tar.gz
echo Extract the package
tar -xvf openshift-client-linux-4.5.0-0.okd-2020-07-14-153706-ga.tar.gz
echo Move oc and kubectl file to your expected directory
sudo mv oc kubectl /usr/local/bin/
echo Now you can start using OC command
oc version