import unittest
from datetime import date, timedelta

from django.test import TestCase

from Gratefulness.journal.projectUtils import projectPath
from Gratefulness.journal.models import Entry

class EntryNearDateTest(TestCase):

    fixtures = map(projectPath,
                   ['journal/tests/journal.json'])

    def setUp(self):
        pass

    def tearDown(self):
        pass

    def assertEntryNearDatePkEq(self, date, tolerance, pk):
        entry = Entry.getEntryNearDate(date, tolerance)
        self.assertNotEqual(entry, None)
        self.assertEqual(entry.pk, pk)

    def assertNoEntryNearDate(self, date, tolerance):
        entry = Entry.getEntryNearDate(date, tolerance)
        self.assertEqual(entry, None)

    def runTest(self):        
        
        # Having an entry exactly on the day requested.
        targetDate = date(2010, 7, 14)
        self.assertEntryNearDatePkEq(targetDate, 
                                     None, 1) 
        self.assertEntryNearDatePkEq(targetDate, 
                                     timedelta(days = 1), 1)                                   
        self.assertEntryNearDatePkEq(targetDate, 
                                     timedelta(weeks = 4), 1)                                      
        self.assertEntryNearDatePkEq(targetDate, 
                                     timedelta(weeks = 60), 1)                                      
        
        # Having no entry anywhere near being in the tolerance range.                                                                
        self.assertNoEntryNearDate(date(1908, 2, 23), 
                                   None)
        self.assertNoEntryNearDate(date(1954, 5, 13), 
                                   timedelta(weeks = 500))
        self.assertNoEntryNearDate(date(1954, 5, 13), 
                                   timedelta(days = 65))
        self.assertNoEntryNearDate(date(1954, 5, 13), 
                                   timedelta(days = 5))
        
        # Entry is just in / out of the tolerance range.
        
        self.assertEntryNearDatePkEq(date(1992, 02, 11),
                                     None, 2)
        self.assertNoEntryNearDate(date(1992, 02, 10), 
                                   None)
        self.assertNoEntryNearDate(date(1992, 02, 9),
                                   None)          
        
        self.assertEntryNearDatePkEq(date(1992, 02, 9),
                                   timedelta(days = 2), 2)
        self.assertNoEntryNearDate(date(1992, 02, 9),
                                   timedelta(days = 1))
        self.assertNoEntryNearDate(date(1992, 02, 13),
                                   timedelta(days = 1))
        
        self.assertEntryNearDatePkEq(date(1992, 02, 4),
                                   timedelta(weeks = 1), 2)
        self.assertEntryNearDatePkEq(date(1992, 02, 9),
                                   timedelta(weeks = 1), 2)
        self.assertEntryNearDatePkEq(date(1992, 02, 18),
                                   timedelta(weeks = 1), 2)
        self.assertEntryNearDatePkEq(date(1992, 02, 13),
                                   timedelta(weeks = 1), 2)                                                        
        self.assertNoEntryNearDate(date(1992, 02, 3),
                                   timedelta(weeks = 1))
        self.assertNoEntryNearDate(date(1992, 02, 19),
                                   timedelta(weeks = 1))

        self.assertEntryNearDatePkEq(date(1992, 01, 14),
                                   timedelta(weeks = 4), 2)
        self.assertEntryNearDatePkEq(date(1992, 01, 28),
                                   timedelta(weeks = 4), 2)        
        self.assertEntryNearDatePkEq(date(1992, 03, 10),
                                   timedelta(weeks = 4), 2)
        self.assertEntryNearDatePkEq(date(1992, 03, 10),
                                   timedelta(weeks = 4), 2)                                                        
        self.assertNoEntryNearDate(date(1992, 01, 6),
                                   timedelta(weeks = 4))
        self.assertNoEntryNearDate(date(1992, 03, 11),
                                   timedelta(weeks = 4))        
        
        # More than one entry is within the tolerance range - pick
        # the closest one.
        
        targetMonth = 7
        targetYear = 1981
        
        # day 16 17 18 19 xx xx 22 23 24 25 26 27 xx xx 30 31 01 02 03
        #  pk  3  4  6  7        8  9 11 12 13 14       15 16 17 18 19 
        #   q       -- ** TT -- --
        
        self.assertEntryNearDatePkEq(date(targetYear, targetMonth, 20),
                                     timedelta(days = 2), 7)
        
        # day 16 17 18 19 xx xx 22 23 24 25 26 27 xx xx 30 31 01 02 03
        #  pk  3  4  6  7        8  9 11 12 13 14       15 16 17 18 19 
        #        -- -- -- -- -- -- -- *T -- -- -- -- -- -- --     
        
        self.assertEntryNearDatePkEq(date(targetYear, targetMonth, 24),
                                     timedelta(weeks = 1), 11)   

        # day 16 17 18 19 xx xx 22 23 24 25 26 27 xx xx 30 31 01 02 03
        #  pk  3  4  6  7        8  9 11 12 13 14       15 16 17 18 19 
        #                                -- *T --     
        
        self.assertEntryNearDatePkEq(date(targetYear, targetMonth, 26),
                                     timedelta(weeks = 1), 13)   

        # day 16 17 18 19 xx xx 22 23 24 25 26 27 xx xx 30 31 01 02 03
        #  pk  3  4  6  7        8  9 11 12 13 14       15 16 17 18 19 
        #                                   -- -- -- TT ** -- --     
        
        self.assertEntryNearDatePkEq(date(targetYear, targetMonth, 29),
                                     timedelta(weeks = 1), 15)   
           
                                   
            
def suite():
    suite = unittest.TestSuite()
    case = EntryNearDateTest()
    suite.addTest(case)
    return suite