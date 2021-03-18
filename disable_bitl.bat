#Type the following command to unlock your BitLocker drive:

#manage-bde -unlock C: -RecoveryPassword YOUR-BITLOCKER-RECOVERY-KEY-HERE



#If your BitLocker recovery key is stored in a file on an external drive, then use this command:

manage-bde -unlock C: -RecoveryKey F:\8A6E787E-BBDE-4E68-9A5B-84F1CF450C20.BEK



#Next turn off BitLocker Encryption:

manage-bde -off C:
