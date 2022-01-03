USE dbSQL1
-- -----------------------------------
-- Screen 8 patients for each study
-- -----------------------------------
--Study 12345
EXECUTE uspScreenNewPatient 1, '04-19-1954', 2, 140, '11-01-2021'
EXECUTE uspScreenNewPatient 2, '05-19-1952', 1, 200, '11-06-2021'
EXECUTE uspScreenNewPatient 3, '07-18-1963', 2, 120, '11-11-2021'
EXECUTE uspScreenNewPatient 2, '05-24-1988', 2, 170, '11-18-2021'
EXECUTE uspScreenNewPatient 2, '11-07-1983', 1, 240, '11-05-2021'
EXECUTE uspScreenNewPatient 1, '04-19-1989', 2, 200, '11-07-2021'
EXECUTE uspScreenNewPatient 3, '04-19-1999', 1, 192, '11-06-2021'
EXECUTE uspScreenNewPatient 1, '05-01-1974', 2, 184, '11-11-2021'

-- Study 54321
EXECUTE uspScreenNewPatient 4, '06-01-1954', 1, 200, '11-09-2021'
EXECUTE uspScreenNewPatient 5, '11-11-1967', 2, 230, '11-13-2021'
EXECUTE uspScreenNewPatient 4, '12-28-1978', 2, 187, '11-08-2021'
EXECUTE uspScreenNewPatient 6, '03-21-1984', 1, 300, '11-11-2021'
EXECUTE uspScreenNewPatient 5, '05-18-1998', 2, 200, '11-09-2021'
EXECUTE uspScreenNewPatient 4, '08-04-1999', 1, 198, '11-10-2021'
EXECUTE uspScreenNewPatient 5, '10-11-1979', 1, 110, '11-02-2021'
EXECUTE uspScreenNewPatient 6, '09-17-2000', 2, 163, '11-01-2021'

---- ------------------------------------
---- Randomize 5 patients for each study
---- ------------------------------------
---- Study 12345
EXECUTE uspRandomizePatient 101001
EXECUTE uspRandomizePatient 111001
EXECUTE uspRandomizePatient 121001
EXECUTE uspRandomizePatient 101002
EXECUTE uspRandomizePatient 121002

-- Study 54321
EXECUTE uspRandomizePatient 501001
EXECUTE uspRandomizePatient 521001
EXECUTE uspRandomizePatient 511002
EXECUTE uspRandomizePatient 521002
EXECUTE uspRandomizePatient 511003

-- -------------------------------------
-- Withdraw 4 patients from each study
-- -------------------------------------
-- Study 12345
EXECUTE uspWithdrawPatient 101001, '04-01-2022', 1
EXECUTE uspWithdrawPatient 111001, '06-01-2022', 3
EXECUTE uspWithdrawPatient 111002, '07-01-2022', 2
EXECUTE uspWithdrawPatient 111003, '08-01-2022', 4

-- Study 54321
EXECUTE uspWithdrawPatient 501001, '09-01-2022', 4
EXECUTE uspWithdrawPatient 521001, '10-01-2022', 5
EXECUTE uspWithdrawPatient 511001, '11-01-2022', 6
EXECUTE uspWithdrawPatient 501002, '12-01-2022', 2
