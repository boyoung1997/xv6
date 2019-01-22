//
//  main.c
//  project1
//
//  Created by 김보영 on 2017. 3. 23..
//  Copyright © 2017년 김보영. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define MAX_SIZE 3000
#define INTERACTIVE 1
#define BATCH 2

char **tok(char *inp, char *sep){

    
    char **str_save = (char**)malloc(sizeof(char*)*strlen(inp)+1);
    int i = 0;

    
    str_save[0] = NULL;

    
    char* ptr = strtok(inp, sep);

    
    if(ptr!=NULL){
        if(strlen(ptr)!=0){
            str_save[i] = malloc(sizeof(char)*strlen(ptr)+1);
            strcpy(str_save[i], ptr);
            i++;
        }
    }

    
    while((ptr = strtok(NULL, sep))){
        if(strlen(ptr) != 0){
            str_save[i] = (char *)malloc(sizeof(char) * (strlen(ptr) + 1));
            strcpy(str_save[i], ptr);
            i++;
        }
    }

    
    str_save[i] = NULL;

    
    if(str_save[0] == NULL)
        return NULL;
    else
        return str_save;

    
}


int main(int argc, char * argv[]) {

    
    FILE *fp;

    
    char str[MAX_SIZE]; //given string
    char **str_1;
    char ***str_2;
    int * tmp;  //store pid temporarily
    int check; //interactive or batch (checking)
    int num = 0, num2 = 0, i = 0; // initializing
    int status;

    
    if(argc > 1){
        check = 2;
        fp = fopen(argv[1], "r");
    }

    
    else if (argc == 1){
        check = 1;
        fp = stdin;
    }

    
    else{
        printf("Input error");
    }

    
    while(1){

        
        num2 = 0;
        if(check == 1){
            printf("prompt>");

            
        }

        
        if(fgets(str, MAX_SIZE, fp) == NULL){
            exit(EXIT_FAILURE);
        }
        str[(strlen(str)-1)] = '\0';

        
        /* using strtok function*/
        str_1 = tok(str, ";");

        
        if(str_1 != NULL){
            for(num=0;str_1[num]!=NULL;){
                num++;
            }
        }

        
        str_2 = (char ***)malloc(sizeof(char **) * (num+1));

        
        for(i=0; i<num; i++){
            str_2[num2] = tok(str_1[i], " ");
            num2++;
            if(str_2[num2-1] == NULL){
                num2--;
            }
        }

        
        tmp = (int *)malloc(sizeof(int) * (num + 1));

        

        
        for(i=0;i<num2;i++){
            pid_t pid;

            
            if (strcmp(str_2[i][0], "quit") == 0)
                exit(0);

            
            if((pid = fork())<0){
                printf("ERROR: forking child process failed\n");
                exit(1);
            }

            
            else if(pid == 0) {
                execvp(str_2[i][0], str_2[i]);
                printf("This statement should not be executed if execvp is successful.\n");
            }

            
            else{
                tmp[i] = pid;
            }

            
        }

        
        for(i = 0; i < num2; i++){
            waitpid(tmp[i], &status, 0);
        }

        
        for(i = 0; i < num2; i++) {
            if(str_2[i] != NULL){
                free(str_2[i]);
            }
        }
        free(str_2);

        
        if(str_1!=NULL)
            free(str_1);

        
        free(tmp);

    }

    
    return 0;
}
	

