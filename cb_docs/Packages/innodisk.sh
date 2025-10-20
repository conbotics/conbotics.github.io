wget https://www.innodisk.com/Download_file?D7856A02AF20333811EBF83A6E6FDFE35B4E9EB6DD07FA3AB88C58D7AD607D01F79F4DBA40DC5C94CFB4FE2416569E75A8EF8A4BA52635BC550EE7B7FED8602DFEF4A4F5B78B01AFEE7045355C253D65827FD666E4FBE8B7849B550EDE5A4386 --output-document ../../innodisk.zip
unzip ../../innodisk.zip "EMUC-B202/Linux/EMUC_B202_SocketCAN_driver_v3.7_utility_v3.3_20230418.zip"
mv EMUC-B202/Linux/EMUC_B202_SocketCAN_driver_v3.7_utility_v3.3_20230418.zip ../../
rm -r EMUC-B202 ../../innodisk.zip
unzip ../../EMUC_B202_SocketCAN_driver_v3.7_utility_v3.3_20230418.zip -d "../../EMUC_B202"
rm ../../EMUC_B202_SocketCAN_driver_v3.7_utility_v3.3_20230418.zip
