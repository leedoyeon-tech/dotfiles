#!/bin/bash
# install.sh - 맥북 개발환경 자동 설정 스크립트

echo "맥북 개발환경 설정을 시작합니다..."

# Homebrew 설치
if ! command -v brew &> /dev/null; then
    echo "Homebrew 설치 중..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Homebrew PATH 설정
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Homebrew가 이미 설치되어 있습니다."
fi

# Git 설치
if ! command -v git &> /dev/null; then
    echo "Git 설치 중..."
    brew install git
else
    echo "Git이 이미 설치되어 있습니다."
fi

# Git 기본 설정
echo "Git 기본 설정 중..."
read -p "Git 사용자 이름을 입력하세요: " git_name
read -p "Git 이메일을 입력하세요: " git_email

git config --global user.name "$git_name"
git config --global user.email "$git_email"
git config --global init.defaultBranch main
git config --global core.editor "vim"
git config --global color.ui true

# Git 전역 .gitignore 설정
cat > $HOME/.gitignore_global << 'EOL'
# macOS
.DS_Store
.AppleDouble
.LSOverride
Icon
._*
.DocumentRevisions-V100
.fseventsd
.Spotlight-V100
.TemporaryItems
.Trashes
.VolumeIcon.icns
.com.apple.timemachine.donotpresent

# 편집기 및 IDE 파일
.idea/
.vscode/
*.sublime-project
*.sublime-workspace
*.swp
*.swo
*~

# 노드 모듈
node_modules/
npm-debug.log
yarn-error.log
yarn-debug.log

# 빌드 결과물
dist/
build/
out/
.next/

# 환경 변수
.env
.env.local
.env.development
.env.test
.env.production
EOL

git config --global core.excludesfile $HOME/.gitignore_global

# Oh My Zsh 설치
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My Zsh 설치 중..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh가 이미 설치되어 있습니다."
fi

# zsh 플러그인 설치
echo "zsh 플러그인 설치 중..."
# zsh-autosuggestions
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

# zsh-syntax-highlighting
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# Powerlevel10k 테마 설치 (선택 사항)
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# AWS CLI 설치
if ! command -v aws &> /dev/null; then
    echo "AWS CLI 설치 중..."
    # macOS용 AWS CLI 직접 설치 (공식 문서 방법)
    curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
    sudo installer -pkg AWSCLIV2.pkg -target /
    rm AWSCLIV2.pkg
    
    # 설치 확인
    aws --version
else
    echo "AWS CLI가 이미 설치되어 있습니다."
fi