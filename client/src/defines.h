#pragma once

#include <stdbool.h>
#include <mysql.h>

struct configuration {
	char *host;
	char *db_username;
	char *db_password;
	unsigned int port;
	char *database;

	char username[128];
	char password[128];
};

static inline int min_int(int a, int b) {
	return a < b ? a : b;
};

static inline MYSQL *STDCALL my_mysql_real_connect(MYSQL *mysql, struct configuration* conf) {
	return mysql_real_connect(
		mysql, 
		conf->host, 
		conf->username,
		conf->password,
		conf->database,
		conf->port,
		NULL,
		CLIENT_MULTI_STATEMENTS | CLIENT_MULTI_RESULTS
	);
}

extern int parse_config(char *path, struct configuration *conf);
extern char *getInput(unsigned int lung, char *stringa, bool hide);
extern bool yesOrNo(char *domanda, char yes, char no, bool predef, bool insensitive);
extern char multiChoice(char *domanda, char choices[], int num);
extern void print_error (MYSQL *conn, char *message);
extern void print_stmt_error (MYSQL_STMT *stmt, char *message);
extern void finish_with_error(MYSQL *conn, char *message);
extern void finish_with_stmt_error(MYSQL *conn, MYSQL_STMT *stmt, char *message, bool close_stmt);
extern bool setup_prepared_stmt(MYSQL_STMT **stmt, char *statement, MYSQL *conn);
extern void dump_result_set(MYSQL *conn, MYSQL_STMT *stmt, char *title);
extern void run_as_passeggero(MYSQL *conn);
extern void run_as_conducente(MYSQL *conn);
extern void run_as_administrator(MYSQL *conn);
