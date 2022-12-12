#!/bin/bash

export $(cat .env | xargs)

lftp -f "
open $HOST
user $USER $PASS
lcd $SOURCEFOLDER
mirror --continue --reverse --delete --verbose $SOURCEFOLDER_HTML $TARGETFOLDER_HTML
bye
"

lftp -f "
open $HOST
user $USER $PASS
lcd $SOURCEFOLDER
mirror --continue --reverse --delete --verbose -x ^\.bundle/ -x ^\.jekyll-cache/ -x ^\vendor/ -x ^\.git/ $SOURCEFOLDER $TARGETFOLDER
bye
"

rsync -ah --exclude-from=exclude-file.txt . $RSYNC_TARGET