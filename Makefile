LIB_NAME		= ALF_std
STC_LIB_PRE		= lib
STC_LIB_EXT		= a
DYN_LIB_PRE		= lib
DYN_LIB_EXT		= so


# Directories
PATH_SEPARATOR	= /
ifeq ($(OS),Windows_NT)
	PATH_SEPARATOR	= \\
endif
SRC_DIR		= src
OBJ_DIR		= obj
INCLUDE_DIR	= include
EXTRA_DIR	= extra
OUT_DIR		= out
DOCS		= docs

O_EXT_DIR	= $(OBJ_DIR)$(PATH_SEPARATOR)$(EXTRA_DIR)
STATIC_DIR	= $(OUT_DIR)$(PATH_SEPARATOR)static
DYNAMIC_DIR	= $(OUT_DIR)$(PATH_SEPARATOR)dynamic

FOLDERS		= $(OBJ_DIR) $(OUT_DIR) $(STATIC_DIR) $(DYNAMIC_DIR) $(O_EXT_DIR)
RM_FOLDERS	= $(OBJ_DIR) $(OUT_DIR) 

MKFILE_PATH	:= $(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_DIR	:= $(notdir $(patsubst %/,%,$(dir $(MKFILE_PATH))))

# Compiler
CC			= @gcc
LANG_EXT	= c
HEADER_EXT	= h
OBJ_EXT		= o
FLAGS		= -Wall -fPIC -I$(INCLUDE_DIR) -O2
SHARED_FLAG	= -shared
DEBUG_FLAG	= -g

# 
AR			= @ar
AR_FLAGS	= cvq

# Doxygen, documentation generator
DOXYGEN		= doxygen 

# Commands
ECHO		= @echo
COPY		= @cp
MOVE		= @mv
MAKEDIR		= mkdir
MKDIR_FLAGS	= -p
REMOVE		= @rm
RM_FLAGS	= -rf

ifeq ($(OS),Windows_NT)
	MKDIR_FLAGS	= 
	REMOVE		= @rd
	RM_FLAGS	= /s /q
	MOVE		= move
endif

all: static_lib dynamic_lib
	$(ECHO) "Done\n"

debug: make_debug_objects ar_static_lib ar_static_extra_lib compile_dynamic_lib compile_dynamic_extra_lib
	$(ECHO) "Debug ready\n"

install: #static_lib dynamic_lib
	$(ECHO) "Not supported yet"

clean:
	$(REMOVE) $(RM_FLAGS) $(RM_FOLDERS)

docs: make_docs_folder doxygen_make_docs
	$(ECHO) "done"

make_docs_folder:
	$(MAKEDIR) $(MKDIR_FLAGS) $(DOCS)

doxygen_make_docs: make_docs_folder
	$(DOXYGEN) docs.conf

clean_docs:
	$(REMOVE) $(RM_FLAGS) $(DOCS)


static_lib: make_objects make_extra_objects ar_static_lib ar_static_extra_lib
	$(ECHO) "\tStatic library done\n"

dynamic_lib: make_objects make_extra_objects compile_dynamic_lib compile_dynamic_extra_lib
	$(ECHO) "\tDynamic library done\n"


makefolders:
	$(ECHO) "Making folders"
	$(MAKEDIR) $(MKDIR_FLAGS) $(FOLDERS)
	$(ECHO) "\tFolders done\n"


make_objects: makefolders
	$(ECHO) "Making objects"
	$(CC) -c $(SRC_DIR)$(PATH_SEPARATOR)*.$(LANG_EXT) $(FLAGS)
	$(ECHO) "->Moving files"
	$(MOVE) *.$(OBJ_EXT) $(OBJ_DIR)/
	$(ECHO) "\tObjects done\n"

make_extra_objects: makefolders
	$(ECHO) "Making extra objects"
	$(CC) -c $(SRC_DIR)$(PATH_SEPARATOR)$(EXTRA_DIR)$(PATH_SEPARATOR)*.$(LANG_EXT) $(FLAGS)
	$(ECHO) "->Moving files"
	$(MOVE) *.$(OBJ_EXT) $(O_EXT_DIR)$(PATH_SEPARATOR)
	$(ECHO) "\tExtra objects done\n"

make_debug_objects: makefolders
	$(ECHO) "Making objects"
	$(CC) -c $(SRC_DIR)$(PATH_SEPARATOR)*.$(LANG_EXT) $(FLAGS) $(DEBUG_FLAG)
	$(ECHO) "->Moving files"
	$(MOVE) *.$(OBJ_EXT) $(OBJ_DIR)$(PATH_SEPARATOR)
	$(ECHO) "\tObjects done\n"
	$(ECHO) "Making extra objects"
	$(CC) -c $(SRC_DIR)$(PATH_SEPARATOR)$(EXTRA_DIR)$(PATH_SEPARATOR)*.$(LANG_EXT) $(FLAGS) $(DEBUG_FLAG)
	$(ECHO) "->Moving files"
	$(MOVE) *.$(OBJ_EXT) $(O_EXT_DIR)$(PATH_SEPARATOR)
	$(ECHO) "\tExtra objects done\n"


ar_static_lib: make_objects
	$(ECHO) "Making static lib"
	$(AR) $(AR_FLAGS) $(STATIC_DIR)$(PATH_SEPARATOR)$(STC_LIB_PRE)$(LIB_NAME).$(STC_LIB_EXT) $(OBJ_DIR)$(PATH_SEPARATOR)*.$(OBJ_EXT)
	$(ECHO) "->Static lib done"

compile_dynamic_lib: make_objects
	$(ECHO) "Making dynamic lib"
	$(CC) $(OBJ_DIR)$(PATH_SEPARATOR)*.$(OBJ_EXT) $(SHARED_FLAG) -o $(DYNAMIC_DIR)$(PATH_SEPARATOR)$(DYN_LIB_PRE)$(LIB_NAME).$(DYN_LIB_EXT)
	$(ECHO) "->Dynamic lib done"

ar_static_extra_lib: make_extra_objects
	$(ECHO) "Making static extra lib"
	$(AR) $(AR_FLAGS) $(STATIC_DIR)$(PATH_SEPARATOR)$(STC_LIB_PRE)$(LIB_NAME)_extra.$(STC_LIB_EXT) $(O_EXT_DIR)$(PATH_SEPARATOR)*.$(OBJ_EXT)
	$(ECHO) "->Static extra lib done"

compile_dynamic_extra_lib: make_extra_objects
	$(ECHO) "Making dynamic extra lib"
	$(CC) $(O_EXT_DIR)$(PATH_SEPARATOR)*.$(OBJ_EXT) $(SHARED_FLAG) -o $(DYNAMIC_DIR)$(PATH_SEPARATOR)$(DYN_LIB_PRE)$(LIB_NAME)_extra.$(DYN_LIB_EXT)
	$(ECHO) "->Dynamic lib done"
