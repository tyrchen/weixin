CHECK=\033[32m✔\033[39m
DONE="\n$(CHECK) Done.\n"

SERVER=weixin
PROJECT=weixin
PATH=deployment/$(PROJECT)
SUPERVISORCTL=/usr/bin/supervisorctl
SSH=/usr/bin/ssh
ECHO=/bin/echo -e
NPM=/usr/bin/npm
SUDO=/usr/bin/sudo


start:
	@export DEBUG=webot* && npm start

clear:
	@clear

test: clear
	@export DEBUG="webot* -*verbose" && export WX_TOKEN=test123 && ./node_modules/.bin/mocha

remote_deploy:
	@$(SSH) -t $(SERVER) "echo Deploy $(PROJECT) to the $(SERVER) server.; cd $(PATH); git pull; make deploy;"

dependency:
	@$(ECHO) "\nInstall project dependencies..."
	@$(NPM) install

configuration:
	@$(ECHO) "\nUpdate configuration..."
	@$(SUDO) $(SUCOPY) -r _deploy/etc/. /etc/.

supervisor:
	@$(ECHO) "\nUpdate supervisor configuration..."
	@$(SUDO) $(SUPERVISORCTL) reread
	@$(SUDO) $(SUPERVISORCTL) update
	@$(ECHO) "\nRestart $(PROJECT)..."
	@$(SUDO) $(SUPERVISORCTL) restart $(PROJECT)

nginx:
	@$(ECHO) "\nRestart nginx..."
	@$(SUDO) /etc/init.d/nginx restart

deploy: dependency configuration supervisor nginx
	@$(ECHO) $(DONE)

