/** \file ALF_sockets.h
* A wrapper for easy use of sockets.
**/

#ifndef ALF_sockets_h
#define ALF_sockets_h

#include "ALF_common.h"
#include <stdint.h>
#include <stdbool.h>

typedef struct {
    int sock_desc;
    struct sockaddr_in *addr;

    int backlog;
    size_t maxRecv;

    bool binded;
    bool listening;
    bool connected;
} ALF_socket;


ALF_socket *ALF_sockets_init(const char *ip, uint16_t port);

void ALF_sockets_free(ALF_socket *handler);

void ALF_sockets_setBacklog(ALF_socket *handler, int backlog);

int ALF_sockets_getBacklog(ALF_socket *handler);

int ALF_sockets_bind(ALF_socket *handler);

int ALF_sockets_connect(ALF_socket *handler);

int ALF_sockets_listen(ALF_socket *handler);

ALF_socket *ALF_sockets_accept(ALF_socket *handler);

char *ALF_sockets_recv(ALF_socket *client_handler, size_t maxRecv);

int ALF_sockets_recv_a(ALF_socket *client_handler, size_t maxRecv, char *msg);

int ALF_sockets_send(ALF_socket *client_handler, const char* msg);


#endif /* ALF_sockets_h */