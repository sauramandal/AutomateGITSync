#!/bin/bash
# Sync all of your local branch up to date with with develop & push changes to your remote...
# Not added yet, modify this in order to automate syncing local branch with remote develop..
repos=(
    "/Documents/design/artifacts/ux-team/prototypes/live-demo",
    "/Documents/API/api/",
    "/Documents/wp2/" 
    # Add multiple directory paths, if you want
)
clear
  
while [ 1 ]; do
    tput cup 3 20
    echo "MAKE A CHOICE, PRESS ENTER/RETURN TO MAKE A CHOICE..\n"
    echo "1. Do you want to continue ? (Press 1 to continue)\n"
    echo "q. Quit (Press q to quit)\n"
    echo "Enter choice"
    read ch
    case $ch in
    1)
        echo "Checking the remote..."
        GET_REMOTE=$(git remote -v | wc -l)
        CURRENT_PATH=$(pwd)
        if [ "$GET_REMOTE" -ne 2 ]; then
            printf "\nOpps! Not a .git repository $CURRENT_PATH\n"
            exit 1
        fi
        git status -sb
        echo "Fetching ..."
        git fetch origin develop
        echo "******************** Showing differences with remote develop branch **********************\n"
        git diff origin/develop
        # Exits if conflicts are probable. 
        CONFLICTS=$(git diff --name-only --diff-filter=U | wc -l)
        if [ "$CONFLICTS" -gt 0 ]; then
            echo "There is a merge conflict. Aborting ...(Hint: Do - git reset / git add .)"
            git merge --abort
            exit 1
        else
            clear
            # Continue to checkout to local branch & do add, commit, push
            git branch #Listing all local branches
            printf "Please enter local branch name: "
            read localBranch
            if [ -z "$localBranch" ]; then
                printf "Cannot continue without local branch!\n\n"
                exit
            fi
            echo "******************************* Showing status ****************************************\n"
            git status -sb
            echo "******************************* Checking out to a local branch ****************************************\n"
            git checkout $localBranch
            echo $(git checkout $localBranch)
            echo "Pulling from remote..."
            git pull origin develop
            # Prompt the user for further actions to perform commits ...
            echo "Want to add -> commit -> push all staged files ? (y / n)"
            read choice
            
            if [ "$choice" = "y" ]; then
                echo "******************************* Showing latest commits ****************************************\n"
                git log --oneline --graph
                echo "******************************* Add files to staging area ****************************************\n"
                git add . -p
                clear
                read -r -p 'Commit description: ' desc
                if [ -z "$desc" ]; then
                    printf "\nExit: commit description is empty!"
                fi
                git commit -m "$desc"
                echo "******************************* Add files to staging area ****************************************\n"
                git push origin $localBranch
                printf "\nEnd local commit on $localBranch; merged and push to branch develop. Well done!\n"
            else
                clear
                echo "****** Bye. Enjoy your day!! ******"
                exit 1
            fi
        fi
        clear
        ;;
    q)
        exit 1
        clear
        ;;
    *)
        echo "INVALID CHOICE"
        clear
        ;;
    esac
done
