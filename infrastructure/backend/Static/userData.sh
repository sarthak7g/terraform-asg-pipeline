#!/bin/bash -xe

## Code Deploy Agent Bootstrap Script##

exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1
AUTOUPDATE=false

function installdep() {

    if [ ${PLAT} = "ubuntu" ]; then

        apt-get -y update
        # Satisfying even ubuntu older versions.
        apt-get -y install jq awscli ruby2.0 || apt-get -y install jq awscli ruby
        echo "Installed Ruby and AWSCLI"
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
        echo "NVM Downloaded"
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
        nvm install v10.19.0
        echo "Installed Node v10.19.0"
        npm install pm2 -g
        sudo env PATH=$PATH:/.nvm/versions/node/v10.19.0/bin /.nvm/versions/node/v10.19.0/lib/node_modules/pm2/bin/^C2 startup systemd -u ubuntu --hp /home/ubuntu
        npm install -g typescript
        echo "Installed PM2 adn type script"
        cat <<EOF >>/home/ubuntu/.bashrc
export NVM_DIR="/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
EOF

    elif

        [ ${PLAT} = "amz" ]
    then
        yum -y update
        yum install -y aws-cli ruby jq

    fi

}

function platformize() {

    #Linux OS detection#
    if hash lsb_release; then
        echo "Ubuntu server OS detected"
        export PLAT="ubuntu"

    elif
        hash yum
    then
        echo "Amazon Linux detected"
        export PLAT="amz"

    else
        echo "Unsupported release"
        exit 1

    fi
}

function execute() {

    if [ ${PLAT} = "ubuntu" ]; then

        cd /tmp/
        wget https://aws-codedeploy-${REGION}.s3.amazonaws.com/latest/install
        chmod +x ./install

        if ./install auto; then
            echo "Instalation completed"
            if ! ${AUTOUPDATE}; then
                echo "Disabling Auto Update"
                sed -i '/@reboot/d' /etc/cron.d/codedeploy-agent-update
                chattr +i /etc/cron.d/codedeploy-agent-update
                rm -f /tmp/install
            fi
            exit 0
        else
            echo "Instalation script failed, please investigate"
            rm -f /tmp/install
            exit 1
        fi

    elif [ ${PLAT} = "amz" ]; then

        cd /tmp/
        wget https://aws-codedeploy-${REGION}.s3.amazonaws.com/latest/install
        chmod +x ./install

        if ./install auto; then
            echo "Instalation completed"
            if ! ${AUTOUPDATE}; then
                echo "Disabling auto update"
                sed -i '/@reboot/d' /etc/cron.d/codedeploy-agent-update
                chattr +i /etc/cron.d/codedeploy-agent-update
                rm -f /tmp/install
            fi
            exit 0
        else
            echo "Instalation script failed, please investigate"
            rm -f /tmp/install
            exit 1
        fi

    else
        echo "Unsupported platform ''${PLAT}''"
    fi

}

platformize
installdep
REGION=$(curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r ".region")
execute
