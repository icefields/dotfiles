# Function for creating a backup file
# ex: backup file.txt
# result: copies file as file.txt.bak
function backup --argument filename
    ~/scripts/shell_common/backup.sh $filename
    # cp $filename $filename.(date +'%Y%m%d').bck
end

