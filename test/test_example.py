#!/usr/bin/env python

import os
import sys
import unittest

sys.path.insert(0, os.path.abspath('../docs/.'))

import example

class TestExample(unittest.TestCase):

    def test_example_funtion(self):
        self.assertEqual(example.example_function(1, 'test', 1), 0,
                         'returns wrong value')
        self.assertEqual(example.example_function(1, 'test', 'test'), 0,
                         'returns wrong value')

    def test_example_function_exception(self):
        with self.assertRaises(TypeError):
            example.example_function('test', 'test', 0)

if __name__ == '__main__':
    unittest.main()