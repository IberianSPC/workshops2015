$Key=(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24)
$secure = read-host -assecurestring
$encrypted = convertfrom-securestring -secureString $secure -key $Key
$encrypted | set-content c:\labfiles\Password.txt