# 25. Write a shell command that accept a filename as argument and displays the last modification time,
# if the file exists and a suitable message if it does not.

#!/bin/bash

if [ -f "$1" ]
then
    stat -c "Last modification time: %y" "$1"
else
    echo "File does not exist."
fi


# 26. Write a shell script which finds out the following:
# a. the last modification time of a file
# b. whether the command line input string is a valid user or not

#!/bin/bash

# a. Last modification time of a file
echo "Enter filename:"
read file

if [ -f "$file" ]
then
    stat -c "Last modification time: %y" "$file"
else
    echo "File does not exist."
fi

# b. Check whether command line input is a valid user
if id "$1" &>/dev/null
then
    echo "$1 is a valid user."
else
    echo "$1 is not a valid user."
fi


# 27. Write a shell script to display the files created or updated fourteen days before from the current date.

#!/bin/bash

find . -type f -mtime 14 -print



# 28. Develop a shell script which displays all files with all attributes
# those have created or modified in the month of November.

#!/bin/bash

find . -type f -newermt "$(date +%Y)-11-01" ! -newermt "$(date +%Y)-12-01" -ls




# 29. Write a shell script that shows the names of all the non-directory files
# in the current directory and calculates the sum of the size of them.

#!/bin/bash

sum=0

for file in *
do
    if [ -f "$file" ]
    then
        echo "$file"
        size=$(stat -c %s "$file")
        sum=$((sum + size))
    fi
done

echo "Total size: $sum bytes"




# 30. Write a shell script to list the name of files under the current directory started with vowels.

#!/bin/bash

for file in [aeiouAEIOU]*
do
    if [ -f "$file" ]
    then
        echo "$file"
    fi
done




# 31. Write a shell script that accepts two directory names bar1 and bar2 as arguments
# and deletes those files in bar2 which are identical to their names in bar1.

#!/bin/bash

if [ "$#" -ne 2 ]
then
    echo "Usage: $0 bar1 bar2"
    exit 1
fi

bar1="$1"
bar2="$2"

for file in "$bar1"/*
do
    name=$(basename "$file")

    if [ -f "$file" ] && [ -f "$bar2/$name" ]
    then
        if cmp -s "$file" "$bar2/$name"
        then
            rm "$bar2/$name"
            echo "Deleted: $bar2/$name"
        fi
    fi
done


# 32. Write a shell script which reads a directory name and compares the files
# in the current directory which has more files and how much more files.

echo "Enter directory name:"
read dir

current_count=$(find . -maxdepth 1 -type f | wc -l)
dir_count=$(find "$dir" -maxdepth 1 -type f | wc -l)

echo "Files in current directory: $current_count"
echo "Files in $dir: $dir_count"

if [ "$current_count" -gt "$dir_count" ]
then
    echo "Current directory has $((current_count - dir_count)) more files."
elif [ "$dir_count" -gt "$current_count" ]
then
    echo "$dir has $((dir_count - current_count)) more files."
else
    echo "Both directories have the same number of files."
fi


# 33. Write a shell script to check the entered file is a blank file or not.
# If not found blank then display the contents of the file.

echo "Enter filename:"
read file

if [ ! -f "$file" ]
then
    echo "File not found."
elif [ ! -s "$file" ]
then
    echo "The file is blank."
else
    echo "The file is not blank."
    echo "Contents of the file:"
    cat "$file"
fi


# 34. Write a shell script to find the total number of words, characters, lines
# in the given file (supplied as command line argument) and check if it is a regular file or not.

if [ -f "$1" ]
then
    echo "It is a regular file."
    echo "Lines: $(wc -l < "$1")"
    echo "Words: $(wc -w < "$1")"
    echo "Characters: $(wc -m < "$1")"
else
    echo "It is not a regular file."
fi


# 35. Write a shell script to concatenate two files and count the number of characters,
# number of words and number of lines in the resultant concatenated file.

echo "Enter first filename:"
read file1

echo "Enter second filename:"
read file2

if [ -f "$file1" ] && [ -f "$file2" ]
then
    cat "$file1" "$file2" > result.txt

    echo "Files concatenated into result.txt"
    echo "Lines: $(wc -l < result.txt)"
    echo "Words: $(wc -w < result.txt)"
    echo "Characters: $(wc -m < result.txt)"
else
    echo "One or both files do not exist."
fi





#!/bin/bash

# ============================================================
# 36. Write a shell script to take the two filename as an input
# and if they are not duplicate file then concatenate them
# otherwise delete the second one.
# ============================================================

echo "Enter first filename:"
read file1

echo "Enter second filename:"
read file2

if [ -f "$file1" ] && [ -f "$file2" ]
then
    if cmp -s "$file1" "$file2"
    then
        echo "Files are duplicate."
        rm "$file2"
        echo "Second file deleted."
    else
        echo "Files are not duplicate."
        cat "$file1" "$file2" > concatenated.txt
        echo "Files concatenated into concatenated.txt"
    fi
else
    echo "One or both files do not exist."
fi


# ============================================================
# 37. Write a shell script, which will receive either the filename
# or the filename with its full path during execution.
# This script should print information about the file as given
# by ls -l command and display it in an informative manner.
# ============================================================

echo
echo "Enter filename or full path:"
read file

if [ -e "$file" ]
then
    echo "File Information:"
    ls -l "$file"
else
    echo "File does not exist."
fi


# ============================================================
# 38. The file /etc/passwd contains information about all the users.
# Write a shell script which would receive the login name during
# execution, obtain information about it from /etc/passwd and
# display this information in an easily understandable format.
# ============================================================

echo
echo "Enter login name:"
read username

user_info=$(grep "^$username:" /etc/passwd)

if [ -n "$user_info" ]
then
    IFS=: read -r login password uid gid comment home shell <<< "$user_info"

    echo "Login Name : $login"
    echo "User ID    : $uid"
    echo "Group ID   : $gid"
    echo "Comment    : $comment"
    echo "Home Dir   : $home"
    echo "Shell      : $shell"
else
    echo "User does not exist."
fi


# ============================================================
# 39. Write a shell script to make a password based menu-driven
# program, which will give three chances to enter the password
# in case of wrong password. If the given password is correct:
# a) Number of users currently logged in.
# b) Calendar of current month.
# c) Date in the format: dd / mm / yyyy.
# d) Exit
# ============================================================

echo
correct_password="admin"
attempt=1
success=0

while [ $attempt -le 3 ]
do
    read -s -p "Enter password: " password
    echo

    if [ "$password" = "$correct_password" ]
    then
        success=1
        break
    else
        echo "Wrong password."
        echo "Attempts remaining: $((3 - attempt))"
    fi

    attempt=$((attempt + 1))
done

if [ $success -eq 1 ]
then
    while true
    do
        echo
        echo "===== MENU ====="
        echo "1. Number of users currently logged in"
        echo "2. Calendar of current month"
        echo "3. Current date"
        echo "4. Exit"
        echo "================"

        read -p "Enter your choice: " choice

        case $choice in
            1)
                who | wc -l
                ;;
            2)
                cal
                ;;
            3)
                date "+%d / %m / %Y"
                ;;
            4)
                echo "Exiting..."
                break
                ;;
            *)
                echo "Invalid choice."
                ;;
        esac
    done
else
    echo "Three wrong attempts. Access denied."
fi


# ============================================================
# 40. Devise a menu-driven shell program which accepts values
# 1 to 4 and performs actions depending upon the number keyed in:
# 1. List of files
# 2. Present date
# 3. Users of the system
# 4. Quit to UNIX.
# ============================================================

while true
do
    echo
    echo "===== MENU ====="
    echo "1. List of files"
    echo "2. Present date"
    echo "3. Users of the system"
    echo "4. Quit to UNIX"
    echo "================"

    read -p "Enter your choice: " choice

    case $choice in
        1)
            ls
            ;;
        2)
            date
            ;;
        3)
            who
            ;;
        4)
            echo "Quit to UNIX."
            break
            ;;
        *)
            echo "Invalid choice. Please enter 1-4."
            ;;
    esac
done






/*
41. Write a program to get the PID of parent and child process.
*/

#include <stdio.h>
#include <unistd.h>

int main()
{
    pid_t pid = fork();

    if (pid == 0)
    {
        printf("Child Process PID  : %d\n", getpid());
        printf("Parent Process PID : %d\n", getppid());
    }
    else
    {
        printf("Parent Process PID : %d\n", getpid());
        printf("Child Process PID  : %d\n", pid);
    }

    return 0;
}


/*
42. Write a program to kill all processes whose PID is even.
*/

#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <dirent.h>

int main()
{
    DIR *dir;
    struct dirent *entry;
    int pid;

    dir = opendir("/proc");

    if (dir == NULL)
    {
        perror("opendir");
        return 1;
    }

    while ((entry = readdir(dir)) != NULL)
    {
        pid = atoi(entry->d_name);

        if (pid > 0 && pid % 2 == 0)
        {
            if (kill(pid, SIGTERM) == 0)
                printf("Killed process with PID: %d\n", pid);
        }
    }

    closedir(dir);

    return 0;
}


/*
43. Implement an orphan process using fork.
*/

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

int main()
{
    pid_t pid = fork();

    if (pid < 0)
    {
        perror("fork");
        return 1;
    }

    if (pid == 0)
    {
        sleep(5);

        printf("Child PID        : %d\n", getpid());
        printf("New Parent PID   : %d\n", getppid());
        printf("Child is now an orphan process.\n");
    }
    else
    {
        printf("Parent PID: %d\n", getpid());
        printf("Parent exiting...\n");
        exit(0);
    }

    return 0;
}


/*
44. Implement a zombie process using fork.
*/

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

int main()
{
    pid_t pid = fork();

    if (pid < 0)
    {
        perror("fork");
        return 1;
    }

    if (pid == 0)
    {
        printf("Child process PID: %d\n", getpid());
        printf("Child exiting...\n");
        exit(0);
    }
    else
    {
        printf("Parent PID: %d\n", getpid());
        printf("Child PID: %d\n", pid);
        printf("Parent sleeping. Child becomes zombie.\n");

        sleep(30);

        printf("Parent exiting...\n");
    }

    return 0;
}


/*
45. Write a program with a local variable and a global variable.
Initialize both of them. The program should fork a child process
and the child should increment both the variables by one.
After this operation, both the parent and the child should print
the values of the variables.
*/

#include <stdio.h>
#include <unistd.h>

int global = 10;

int main()
{
    int local = 20;

    pid_t pid = fork();

    if (pid < 0)
    {
        perror("fork");
        return 1;
    }

    if (pid == 0)
    {
        global++;
        local++;

        printf("Child Process:\n");
        printf("Global variable = %d\n", global);
        printf("Local variable  = %d\n", local);
    }
    else
    {
        printf("Parent Process:\n");
        printf("Global variable = %d\n", global);
        printf("Local variable  = %d\n", local);
    }

    return 0;
}




/*
46. Implement the assignment no. 47 using vfork for spawning the child.
*/

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/utsname.h>

int main()
{
    pid_t pid = vfork();

    if (pid < 0)
    {
        perror("vfork");
        exit(1);
    }

    if (pid == 0)
    {
        struct utsname info;

        if (uname(&info) == 0)
        {
            printf("System Name : %s\n", info.sysname);
            printf("Node Name   : %s\n", info.nodename);
            printf("Release     : %s\n", info.release);
            printf("Version     : %s\n", info.version);
            printf("Machine     : %s\n", info.machine);
        }

        sleep(50);
        _exit(0);
    }

    printf("Parent process completed.\n");

    return 0;
}


/*
47. Write a program to create a process which will run as a background
process for fifty seconds and at the time of execution it will print
the system information.
*/

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/utsname.h>

int main()
{
    pid_t pid = fork();

    if (pid < 0)
    {
        perror("fork");
        return 1;
    }

    if (pid == 0)
    {
        struct utsname info;

        if (uname(&info) == 0)
        {
            printf("System Name : %s\n", info.sysname);
            printf("Node Name   : %s\n", info.nodename);
            printf("Release     : %s\n", info.release);
            printf("Version     : %s\n", info.version);
            printf("Machine     : %s\n", info.machine);
        }

        printf("Background process PID: %d\n", getpid());

        sleep(50);

        exit(0);
    }
    else
    {
        printf("Parent exiting. Child is running in background.\n");
    }

    return 0;
}


/*
48. Display the process in the system every thirty seconds but five times.
*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main()
{
    int i;

    for (i = 1; i <= 5; i++)
    {
        printf("\nProcess list %d:\n", i);

        system("ps");

        if (i < 5)
            sleep(30);
    }

    return 0;
}


/*
49. Write a program for a process which cannot be killed by pressing
Ctrl + C and again restore the default status of it.
(Print necessary messages where required).
*/

#include <stdio.h>
#include <signal.h>
#include <unistd.h>

void handler(int sig)
{
    printf("\nCtrl + C ignored.\n");
}

int main()
{
    int i;

    signal(SIGINT, handler);

    printf("Ctrl + C is currently ignored.\n");

    for (i = 1; i <= 10; i++)
    {
        printf("Running... %d\n", i);
        sleep(1);
    }

    signal(SIGINT, SIG_DFL);

    printf("Default Ctrl + C behavior restored.\n");
    printf("Now press Ctrl + C to terminate the process.\n");

    while (1)
    {
        sleep(1);
    }

    return 0;
}


/*
50. Write a program that creates two child processes.
Each child process prints numbers from 1 to 10.
Each time a child prints a number it also prints its own PID
and parent PID. The parent waits for both children to finish
and prints "Good Bye" before exiting.
*/

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/wait.h>

int main()
{
    pid_t pid1, pid2;
    int i;

    pid1 = fork();

    if (pid1 == 0)
    {
        for (i = 1; i <= 10; i++)
        {
            printf("Child 1: Number = %d, PID = %d, PPID = %d\n",
                   i, getpid(), getppid());
            sleep(1);
        }

        exit(0);
    }

    pid2 = fork();

    if (pid2 == 0)
    {
        for (i = 1; i <= 10; i++)
        {
            printf("Child 2: Number = %d, PID = %d, PPID = %d\n",
                   i, getpid(), getppid());
            sleep(1);
        }

        exit(0);
    }

    waitpid(pid1, NULL, 0);
    waitpid(pid2, NULL, 0);

    printf("Good Bye\n");

    return 0;
}


/*
51. Write a program that creates three child processes.
The first child executes "who", the second executes "ls -l",
and the third executes "date".
The parent waits for all children and prints their termination status.
*/

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/wait.h>

int main()
{
    pid_t pid1, pid2, pid3;
    pid_t pid;
    int status;
    int i;

    pid1 = fork();

    if (pid1 == 0)
    {
        execlp("who", "who", NULL);
        perror("execlp");
        exit(1);
    }

    pid2 = fork();

    if (pid2 == 0)
    {
        execlp("ls", "ls", "-l", NULL);
        perror("execlp");
        exit(1);
    }

    pid3 = fork();

    if (pid3 == 0)
    {
        execlp("date", "date", NULL);
        perror("execlp");
        exit(1);
    }

    for (i = 0; i < 3; i++)
    {
        pid = wait(&status);

        if (WIFEXITED(status))
        {
            printf("Child PID %d terminated with status %d\n",
                   pid, WEXITSTATUS(status));
        }
        else
        {
            printf("Child PID %d terminated abnormally.\n", pid);
        }
    }

    return 0;
}


/*
52. Write a program which takes a value of delay as command line
argument and creates a child process.

The parent waits for the child process to finish its job up to
the supplied delay value. If the child terminates within the delay,
the parent prints the termination status and PID.

If the child does not terminate within the delay, the parent
kills the child process forcefully.
*/

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <signal.h>
#include <sys/wait.h>

int main(int argc, char *argv[])
{
    pid_t pid;
    int delay;
    int status;
    int i;

    if (argc != 2)
    {
        printf("Usage: %s <delay>\n", argv[0]);
        return 1;
    }

    delay = atoi(argv[1]);

    pid = fork();

    if (pid < 0)
    {
        perror("fork");
        return 1;
    }

    if (pid == 0)
    {
        printf("Child PID: %d\n", getpid());

        /* Simulating some work */
        sleep(5);

        printf("Child completed its job.\n");

        exit(0);
    }
    else
    {
        for (i = 0; i < delay; i++)
        {
            pid_t result = waitpid(pid, &status, WNOHANG);

            if (result == pid)
            {
                printf("Child PID %d terminated within delay.\n", pid);

                if (WIFEXITED(status))
                {
                    printf("Termination status: %d\n",
                           WEXITSTATUS(status));
                }

                return 0;
            }

            sleep(1);
        }

        printf("Child did not finish within %d seconds.\n", delay);
        printf("Killing child PID %d forcefully.\n", pid);

        kill(pid, SIGKILL);

        waitpid(pid, &status, 0);

        printf("Child process killed.\n");
    }

    return 0;
}




/*
============================================================
53. What is a signal? Show appropriate programs that
demonstrate the following signals:
a. SIGINT
b. SIGHUP
c. SIGCLD
============================================================

A signal is a software interrupt sent to a process to notify
it that a particular event has occurred.

a. SIGINT
    Generated when Ctrl+C is pressed.

b. SIGHUP
    Generated when a terminal/session is disconnected.

c. SIGCLD / SIGCHLD
    Sent to a parent process when a child process terminates.

------------------------------------------------------------
53(a). Demonstrate SIGINT
------------------------------------------------------------
*/

#include <stdio.h>
#include <signal.h>
#include <unistd.h>

void sigint_handler(int sig)
{
    printf("\nSIGINT signal received.\n");
}

int main()
{
    signal(SIGINT, sigint_handler);

    printf("Press Ctrl+C to generate SIGINT.\n");

    while (1)
    {
        sleep(1);
    }

    return 0;
}


/*
------------------------------------------------------------
53(b). Demonstrate SIGHUP
------------------------------------------------------------
*/

#include <stdio.h>
#include <signal.h>
#include <unistd.h>

void sighup_handler(int sig)
{
    printf("SIGHUP signal received.\n");
}

int main()
{
    signal(SIGHUP, sighup_handler);

    printf("Process PID: %d\n", getpid());
    printf("Waiting for SIGHUP...\n");

    while (1)
    {
        sleep(1);
    }

    return 0;
}


/*
------------------------------------------------------------
53(c). Demonstrate SIGCLD / SIGCHLD
------------------------------------------------------------
*/

#include <stdio.h>
#include <signal.h>
#include <unistd.h>
#include <stdlib.h>

void child_handler(int sig)
{
    printf("SIGCHLD signal received: Child terminated.\n");
}

int main()
{
    pid_t pid;

    signal(SIGCHLD, child_handler);

    pid = fork();

    if (pid == 0)
    {
        printf("Child process running...\n");
        sleep(2);
        printf("Child process terminating...\n");
        exit(0);
    }
    else
    {
        printf("Parent waiting for child...\n");

        while (1)
        {
            sleep(1);
        }
    }

    return 0;
}


/*
============================================================
54. Write a program to create a child process and send a
SIGCLD signal to the parent process.
============================================================
*/

#include <stdio.h>
#include <signal.h>
#include <unistd.h>
#include <stdlib.h>

void parent_handler(int sig)
{
    printf("Parent received SIGCLD/SIGCHLD signal.\n");
}

int main()
{
    pid_t pid;

    signal(SIGCHLD, parent_handler);

    pid = fork();

    if (pid < 0)
    {
        perror("fork");
        return 1;
    }

    if (pid == 0)
    {
        printf("Child process running...\n");
        sleep(2);

        printf("Child sending SIGCHLD to parent...\n");
        kill(getppid(), SIGCHLD);

        exit(0);
    }
    else
    {
        printf("Parent PID: %d\n", getpid());

        sleep(5);
        printf("Parent process exiting.\n");
    }

    return 0;
}


/*
============================================================
55. Write a program to print the default message of SIGINT
signal and also print the user.
============================================================
*/

#include <stdio.h>
#include <signal.h>
#include <unistd.h>
#include <pwd.h>

void sigint_handler(int sig)
{
    struct passwd *pw;

    printf("\nSIGINT signal received.\n");

    pw = getpwuid(getuid());

    if (pw != NULL)
    {
        printf("User: %s\n", pw->pw_name);
    }

    printf("SIGINT handler executed.\n");
}

int main()
{
    signal(SIGINT, sigint_handler);

    printf("Press Ctrl+C to generate SIGINT.\n");

    while (1)
    {
        sleep(1);
    }

    return 0;
}


/*
============================================================
56. Write a program to get an interrupt from machine and
display that value of that signal.
============================================================
*/

#include <stdio.h>
#include <signal.h>
#include <unistd.h>

void signal_handler(int sig)
{
    printf("\nSignal received: %d\n", sig);
}

int main()
{
    int i;

    for (i = 1; i < 32; i++)
    {
        signal(i, signal_handler);
    }

    printf("Process PID: %d\n", getpid());
    printf("Waiting for a signal...\n");

    while (1)
    {
        pause();
    }

    return 0;
}


/*
============================================================
57. Process A and Process B normally sleep, except when
process A receives SIGUSR1 and process B receives SIGUSR2.
When both processes receive their respective signals,
both processes print "I am awake".
============================================================
*/

#include <stdio.h>
#include <signal.h>
#include <unistd.h>
#include <stdlib.h>

volatile sig_atomic_t awakeA = 0;
volatile sig_atomic_t awakeB = 0;

void handlerA(int sig)
{
    awakeA = 1;
}

void handlerB(int sig)
{
    awakeB = 1;
}

int main()
{
    pid_t processA, processB;

    processA = fork();

    if (processA < 0)
    {
        perror("fork");
        return 1;
    }

    if (processA == 0)
    {
        /* Process A */
        signal(SIGUSR1, handlerA);

        printf("Process A PID: %d\n", getpid());
        printf("Process A is sleeping...\n");

        while (!awakeA)
        {
            pause();
        }

        printf("Process A: I am awake\n");

        exit(0);
    }

    processB = fork();

    if (processB < 0)
    {
        perror("fork");
        return 1;
    }

    if (processB == 0)
    {
        /* Process B */
        signal(SIGUSR2, handlerB);

        printf("Process B PID: %d\n", getpid());
        printf("Process B is sleeping...\n");

        while (!awakeB)
        {
            pause();
        }

        printf("Process B: I am awake\n");

        exit(0);
    }

    /* Parent process */
    printf("Parent PID: %d\n", getpid());
    printf("Process A PID: %d\n", processA);
    printf("Process B PID: %d\n", processB);

    sleep(5);

    printf("\nSending SIGUSR1 to Process A...\n");
    kill(processA, SIGUSR1);

    printf("Sending SIGUSR2 to Process B...\n");
    kill(processB, SIGUSR2);

    sleep(2);

    printf("Parent process exiting.\n");

    return 0;
}




/*
============================================================
58. Write a program which will supply your response to a
signal created by you.
============================================================
*/

#include <stdio.h>
#include <signal.h>
#include <unistd.h>

void signal_handler(int sig)
{
    printf("\nSignal %d received.\n", sig);
    printf("Response: Signal handled successfully!\n");
}

int main()
{
    signal(SIGUSR1, signal_handler);

    printf("Process PID: %d\n", getpid());
    printf("Send SIGUSR1 using:\n");
    printf("kill -SIGUSR1 %d\n", getpid());

    while (1)
    {
        pause();
    }

    return 0;
}

/*
============================================================
59(a). Initialize a semaphore named 'semhitinit', using a
semaphore key, a long integer used as an identifier by which
semaphore will be known to other processes.
============================================================
*/

#include <stdio.h>
#include <stdlib.h>
#include <sys/ipc.h>
#include <sys/sem.h>

union semun
{
    int val;
    struct semid_ds *buf;
    unsigned short *array;
};

int main()
{
    key_t key;
    int semid;
    union semun arg;

    /* Generate a semaphore key */
    key = ftok(".", 'A');

    if (key == -1)
    {
        perror("ftok");
        exit(1);
    }

    /* Create semaphore */
    semid = semget(key, 1, IPC_CREAT | 0666);

    if (semid == -1)
    {
        perror("semget");
        exit(1);
    }

    /* Initialize semaphore to 0 */
    arg.val = 0;

    if (semctl(semid, 0, SETVAL, arg) == -1)
    {
        perror("semctl");
        exit(1);
    }

    printf("Semaphore initialized successfully.\n");
    printf("Semaphore ID: %d\n", semid);
    printf("Semaphore Key: %ld\n", (long)key);

    return 0;
}

/*
============================================================
59(b). Program semhit1.

semhit1 releases/signals the semaphore so that semhit2,
which may have been started earlier, can continue.
============================================================
*/

#include <stdio.h>
#include <stdlib.h>
#include <sys/ipc.h>
#include <sys/sem.h>

struct sembuf operation;

int main()
{
    key_t key;
    int semid;

    key = ftok(".", 'A');

    if (key == -1)
    {
        perror("ftok");
        exit(1);
    }

    semid = semget(key, 1, 0666);

    if (semid == -1)
    {
        perror("semget");
        exit(1);
    }

    /*
     * Increment semaphore value.
     * This wakes up semhit2 if it is waiting.
     */
    operation.sem_num = 0;
    operation.sem_op = +1;
    operation.sem_flg = 0;

    if (semop(semid, &operation, 1) == -1)
    {
        perror("semop");
        exit(1);
    }

    printf("semhit1 executed.\n");
    printf("Semaphore released. semhit2 can continue.\n");

    return 0;
}

/*
============================================================
59(c). Program semhit2.

semhit2 can be initiated at any time, but it will be forced
to wait until semhit1 is executed.
============================================================
*/

#include <stdio.h>
#include <stdlib.h>
#include <sys/ipc.h>
#include <sys/sem.h>

struct sembuf operation;

int main()
{
    key_t key;
    int semid;

    key = ftok(".", 'A');

    if (key == -1)
    {
        perror("ftok");
        exit(1);
    }

    semid = semget(key, 1, 0666);

    if (semid == -1)
    {
        perror("semget");
        exit(1);
    }

    printf("semhit2 started.\n");
    printf("Waiting for semhit1...\n");

    /*
     * Decrement semaphore.
     *
     * If semaphore value is 0, this process blocks.
     * When semhit1 increments it, semhit2 continues.
     */
    operation.sem_num = 0;
    operation.sem_op = -1;
    operation.sem_flg = 0;

    if (semop(semid, &operation, 1) == -1)
    {
        perror("semop");
        exit(1);
    }

    printf("semhit1 has been executed.\n");
    printf("semhit2 is now running.\n");

    return 0;
}



