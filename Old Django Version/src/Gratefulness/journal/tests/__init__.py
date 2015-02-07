import unittest
import entryTests

def suite():
    suite = unittest.TestSuite()
    suite.addTest(entryTests.suite())
    return suite