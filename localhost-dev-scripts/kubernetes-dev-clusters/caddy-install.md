ubuntu@localhost:~$ history 200
    1  mc
    2  cd /var/lib/cloud/scripts/
    3  ls
    4  ls per boot
    5  ls per-boot
    6  ls per-once
    7  sudo disable_gui.sh
    8  cd~
    9  sudo /var/lib/cloud/scripts/disable_gui.sh
   10  ls
   11  sudo shutdown
   12  echo 'password' | sshfs tester@10.0.2.2:/ ./shared -p2223
   13  mkdir shared
   14  echo 'password' | sshfs tester@10.0.2.2:/ ./shared -p2223
   15  mc
   16  nvm --version
   17  nvm install 16
   18  sudo apt update
   19  sodo sh configureproxy.sh
   20  sudo sh configureproxy.sh
   21  sh configureproxy.sh
   22  curl google.de
   23  sudo reboot
   24  echo 'password' | sshfs tester@10.0.2.2:/ ./shared -p2223
   25  curl google.de
   26  sudo shutdown
   27  sudo apt install nginx -y
   28  sudo systemctl start nginx
   29  sudo systemctl enable nginx
   30  sudo apt install apache2-utils
   31  sudo htpasswd -c /etc/nginx/.htpasswd admin
   32  sudo nano /etc/nginx/sites-available/default
   33  sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/
   34  ls -l /etc/nginx/sites-enabled/default
   35  sudo rm /etc/nginx/sites-enabled/default
   36  sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/
   37  sudo systemctl restart nginx
   38  curl -sS https://rancher-mirror.rancher.cn/autok3s/install.sh | sudo sh
   39  sudo nano /etc/nginx/sites-available/default
   40  sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/
   41  sudo rm /etc/nginx/sites-enabled/default
   42  sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/
   43  sudo systemctl restart nginx
   44  sudo systemctl is-enabled nginx
   45  sudo nano /etc/systemd/system/autok3s.service
   46  systemctl daemon-reload
   47  systemctl enable autok3s
   48  sudo systemctl start autok3s
   49  sudo journalctl -u autok3s
   50  ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N ""
   51  cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
   52  chmod 600 ~/.ssh/authorized_keys
   53  autok3s   create --provider  native --docker-script  https://get.docker.com --k3s-channel  stable --k3s-install-script  https://get.k3s.io --name  localhost --rollback --ssh-key-path  ~/.ssh/id_rsa --ssh-port  22 --ssh-user  ubuntu --master-ips  127.0.0.1
   54  autok3s kubectl config use-context localhost
   55  autok3s list
   56  sudo nano /etc/nginx/sites-available/default
   57  sudo systemctl restart nginx
   58  sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/
   59  sudo rm /etc/nginx/sites-enabled/default
   60  sudo nano /etc/nginx/sites-available/default
   61  sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/
   62  sudo systemctl restart nginx
   63  websocat ws://127.0.0.1:8080/v1/subscribe
   64  sudo nano /etc/nginx/sites-available/default
   65  sudo systemctl reload nginx
   66  sudo systemctl restart nginx
   67  sudo nano /etc/nginx/sites-available/default
   68  sudo systemctl restart nginx
   69  sudo nano /etc/nginx/sites-available/default
   70  sudo systemctl restart nginx
   71  sudo nano /etc/nginx/sites-available/default
   72  sudo systemctl restart nginx
   73  sudo nano /etc/nginx/sites-available/default
   74  sudo systemctl restart nginx
   75  sudo nano /etc/nginx/sites-available/default
   76  sudo systemctl restart nginx
   77  sudo nano /etc/nginx/sites-available/default
   78  sudo apt update
   79  sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https
   80  curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
   81  curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
   82  sudo apt update
   83  sudo apt install -y caddy
   84  caddy version
   85  sudo nano /etc/caddy/Caddyfile
   86  sudo systemctl enable caddy
   87  sudo systemctl status caddy
   88  sudo journalctl -u caddy
   89  sudo systemctl restart caddy
   90  sudo journalctl -u caddy
   91  sudo journalctl -u caddy -f
   92  sudo nano /etc/caddy/Caddyfile
   93  sudo systemctl restart caddy
   94  sudo journalctl -u caddy -f
   95  sudo journalctl -u caddy
   96  sudo nano /etc/caddy/Caddyfile
   97  sudo systemctl restart caddy
   98  sudo journalctl -u caddy -f
   99  sudo nano /etc/caddy/Caddyfile
  100  sudo systemctl restart caddy
  101  sudo journalctl -u caddy -f
  102  sudo nano /etc/caddy/Caddyfile
  103* udo systemctl restart caddy
  104  sudo cat  /etc/caddy/Caddyfile
  105  history 200


sudo apt install -y caddy
sudo nano /etc/caddy/Caddyfile
sudo systemctl restart caddy
sudo journalctl -u caddy


# Refer to the Caddy docs for more information:
# https://caddyserver.com/docs/caddyfile


# This section defines the domain and port where Caddy will listen
:8087 {
    # Enable basic authentication
    basicauth * {
        # Format: <username> <password>
        # Example: admin hiccup
        admin $2a$14$Zkx19XLiW6VYouLHR5NmfOFU0z2GTNmpkT/5qqR7hx4IjWJPDhjvG
    }

    # Proxy all traffic to the autok3s backend
    reverse_proxy localhost:8080

    # Enable WebSocket support
    @websockets {
        header Connection *Upgrade*
        header Upgrade websocket
    }
    reverse_proxy @websockets localhost:8080

    # CORS settings to allow external requests
    header {
        Access-Control-Allow-Origin *
        Access-Control-Allow-Methods "GET, POST, OPTIONS, PUT, DELETE"
        Access-Control-Allow-Headers "Content-Type, Authorization"
    }
}


