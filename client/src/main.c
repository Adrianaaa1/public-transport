#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <mysql.h>

#include "defines.h"

static void login(MYSQL* conn);
static uint8_t attempt_login(MYSQL* conn, const char* username, const char* password);

static struct configuration conf = {
	.host = "localhost",
	.username = "root",
	.password = "password",
	.database = "sistematrasportopubblico3",
	.port = 3306,
};

static struct login_info {
	char* login_message;
	uint8_t role_id;
	void (*run_as_role)(MYSQL*);
} login_info[4] = {
	{ .login_message = "Impossibile efettuare il login, le credenziali potrebbero essere errate.", .run_as_role = login },
	{ .role_id = 1, .login_message = "Connessione riuscita come amministratore", .run_as_role = run_as_administrator },
	{ .role_id = 2, .login_message = "Connessione riuscita come conducente", .run_as_role = run_as_conducente },
	{ .role_id = 3, .login_message = "Connessione riuscita come passeggero", .run_as_role = run_as_passeggero }
};

int main(int argc, const char* argv[]) {
	MYSQL* conn;
	if ((conn = mysql_init(NULL)) == NULL) {
		fprintf(stderr, "mysql_init() failed (probably out of memory)\n");
		goto fail;
	}
	if (my_mysql_real_connect(conn, &conf) == NULL) {
		print_error(conn, "mysql_real_connect() failed\n");
		goto fail2;
	}
	int choise;
	printf("\nSistema di trasporto pubblico\n\n");
	while (true) {
		printf("Seleziona operazione\n\
				\r1) Login\n\
				\r2) Esci\n\
				\r> "
		);
		scanf_s("%d", &choise);
		switch (choise) {
		case 1:
			login(conn);
			break;
		case 2:
			mysql_close(conn);
			return EXIT_SUCCESS;
		}
	}
fail2:
	mysql_close(conn);
fail:
	return EXIT_FAILURE;
}

void login(MYSQL* conn) {
	uint8_t role_id;
	char username[25];
	char password[25];
	printf("\nLogin\n\n");
	printf("Username: ");
	scanf_s("%s", &username, (unsigned int)sizeof username);
	printf("Password: ");
	scanf_s("%s", &password, (unsigned int)sizeof password);
	role_id = attempt_login(conn, username, password);
	uint8_t login_info_index = 0;
	for (uint8_t i = 0; i < sizeof login_info / sizeof * login_info; i++) {
		if (login_info[i].role_id == role_id) {
			login_info_index = i;
		}
	}
	printf("\n%s\n", login_info[login_info_index].login_message);
	login_info[login_info_index].run_as_role(conn);
}

static uint8_t attempt_login(MYSQL* conn, const char* username, const char* password) {
	int role;
	MYSQL_STMT* login_procedure;
	MYSQL_BIND in_param[3];
	MYSQL_BIND out_param[1];
	memset(in_param, 0, sizeof in_param);
	memset(out_param, 0, sizeof out_param);
	in_param[0].buffer_type = MYSQL_TYPE_VAR_STRING;
	in_param[0].buffer = (void*)username;
	in_param[0].buffer_length = strlen(username);
	in_param[1].buffer_type = MYSQL_TYPE_VAR_STRING;
	in_param[1].buffer = (void*)password;
	in_param[1].buffer_length = strlen(password);
	out_param[0].buffer_type = MYSQL_TYPE_LONG;
	out_param[0].buffer = &role;
	out_param[0].buffer_length = sizeof role;
	if (!setup_prepared_stmt(&login_procedure, "call Login(?, ?, ?)", conn)) {
		print_stmt_error(login_procedure, "Unable to initialize login statement\n");
		goto fail;
	}
	if (mysql_stmt_bind_param(login_procedure, in_param) != 0) {
		print_stmt_error(login_procedure, "Could not bind parameters for login");
		goto err;
	}
	if (mysql_stmt_execute(login_procedure) != 0) {
		print_stmt_error(login_procedure, "Could not execute login procedure");
		goto err;
	}
	if (mysql_stmt_bind_result(login_procedure, out_param)) {
		print_stmt_error(login_procedure, "Could not retrieve output parameter");
		goto err;
	}
	if (mysql_stmt_fetch(login_procedure)) {
		print_stmt_error(login_procedure, "Could not buffer results");
		goto err;
	}
	mysql_stmt_close(login_procedure);
	return role;
err:
	mysql_stmt_close(login_procedure);
fail:
	return 0;
}
