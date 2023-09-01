if [[ -z ${TF_VAR_team_number+x} ]]; then
    echo "TF_VAR_team_number not set"
    read -p 'Enter your Team Number 1,2 or 3: ' tn
    if [[ $tn =~ ^[1-3]{1}$ ]]; then
        export TF_VAR_team_number=${tn}
        echo "export TF_VAR_team_number=${tn}" | tee -a ~/.bash_profile
    else
        echo "Please enter a team number between 1 and 3"
        exit
    fi
    

fi
if [[ -z ${TF_VAR_remote_acct_1+x} ]]; then
    echo "TF_VAR_remote_acct_1 not set"
    read -p 'Enter Remote Account ID 1: ' a1
    if [[ $a1 =~ ^[0-9]{12}$ ]]; then
        echo "Account 1 = $a1"
        export TF_VAR_remote_acct_1=${a1}
        echo "export TF_VAR_remote_acct_1=${a1}" | tee -a ~/.bash_profile
    else
        echo "Please enter a 12 digit AWS account number"
        exit
    fi
    
fi
if [[ -z ${TF_VAR_remote_acct_2+x} ]]; then
    echo "TF_VAR_remote_acct_2 not set"
    read -p 'Enter Remote Account ID 2: ' a2
    if [[ $a2 =~ ^[0-9]{12}$ ]]; then
        echo "Account 2 = $a2"
        export TF_VAR_remote_acct_2=${a2}
        echo "export TF_VAR_remote_acct_2=${a2}" | tee -a ~/.bash_profile
        
    else
        echo "Please enter a 12 digit AWS account number"
        exit
    fi
    
fi
if [[ -z ${TF_VAR_central_acct+x} ]]; then
    echo "TF_VAR_central_acct not set"
    read -p 'Enter Remote Account ID for Central Account: ' c1
    if [[ $c1 =~ ^[0-9]{12}$ ]]; then
        echo "Central Account = $c1"
        export TF_VAR_central_acct=${c1}
        echo "export TF_VAR_central_acct=${c1}" | tee -a ~/.bash_profile
        
    else
        echo "Please enter a 12 digit AWS account number"
        exit
    fi
    
fi


acct=$(aws sts get-caller-identity --query Account --output text)
echo "Local Account  = $acct"
echo "Team Number = $TF_VAR_team_number"
echo "Remote Account 1  = $TF_VAR_remote_acct_1" 
echo "Remote Account 2  = $TF_VAR_remote_acct_2"
echo "Central Account   = $TF_VAR_central_acct"
echo " "
echo "now do..."
echo "source ~/.bash_profile"
