# Make sure Pip Package Manager is installed

# Install Venv Module
sudo apt install python3-venv

# create a directory

mk ~/clchatgpt

# create virtual environment
python3 -m venv chatenv

# activate the environment
source chatenv/bin/activate

# create a gpt API Keys
export OPENAI_API_KEY=<your_OpenAI_API_key_bere> > ~/.bashrc
# you can varify by running `env` 

pip3 install shell-gpt --user


# https://beebom.com/how-use-chatgpt-linux-terminal/
# there is different search mode on `sgpt`


