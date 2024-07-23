bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install

uuid=$(/usr/local/bin/xray uuid)
keys=$(/usr/local/bin/xray x25519)

private_key=$(echo "$keys" | grep "Private key:" | awk '{print $3}')
public_key=$(echo "$keys" | grep "Public key:" | awk '{print $3}')

short_id=$(openssl rand -hex 8)
ip=$(hostname -I | cut -d' ' -f1)

sed -i -e s/CUSTOM_UUID/$uuid/g config.json
sed -i -e s/CUSTOM_SHORT_ID/$short_id/g config.json
sed -i -e s/CUSTOM_PRIVATE_KEY/$private_key/g config.json

cp config.json /usr/local/etc/xray/config.json

systemctl restart xray

echo "IP:"
echo $ip
echo "uuid:"
echo $uuid
echo "public_key: (Reality Pbk)"
echo $public_key
echo "short_id: (Reality Sid)"
echo $short_id
echo 
echo "link:"
echo "vless://$uuid@$ip:443?security=reality&sni=www.microsoft.com&fp=chrome&pbk=$public_key&sid=$short_id&type=tcp&flow=xtls-rprx-vision&encryption=none#x"