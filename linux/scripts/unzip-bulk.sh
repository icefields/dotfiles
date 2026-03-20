for file in *.zip; do
    [ -f "$file" ] || continue
    unzip "$file" -d "${file%%.zip}"
done
