# Alpine is smaller but there are issues with glibc dependencies
FROM python:3.9

# Update packages
RUN apt update && apt-get update && apt -y upgrade && apt-get -y upgrade

# Install packages
RUN apt install -y curl zsh grep nano git xclip xsel && apt-get install -y fzf build-essential libssl-dev libffi-dev python-dev

# Install oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install micro text-editor
RUN curl https://getmic.ro | bash && mv micro /usr/bin

# Set directory
WORKDIR /root

# Copy everything from the repo config's folder to the
# WORKDIR path above
# Attention: The copy follows folder structure!
COPY /config .

# Install p10k theme
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Install oh-my-zsh plugins
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
RUN git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions

# Set zsh as default shell
RUN chsh -s $(which zsh)

CMD [ "/bin/zsh" ]