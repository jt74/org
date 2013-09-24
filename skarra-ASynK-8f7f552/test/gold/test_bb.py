##
## Created       : Sat Apr 07 20:03:04 IST 2012
## Last Modified : Thu Jul 12 14:19:13 IST 2012
##
## Copyright (C) 2012 Sriram Karra <karra.etc@gmail.com>
##
## This file is part of ASynK
##
## ASynK is free software: you can redistribute it and/or modify it under
## the terms of the GNU Affero General Public License as published by the
## Free Software Foundation, version 3 of the License
##
## ASynK is distributed in the hope that it will be useful, but WITHOUT
## ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
## FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public
## License for more details.
##
## You should have a copy of the license in the doc/ directory of ASynK.  If
## not, see <http://www.gnu.org/licenses/>.
##
#####
##
## This unit test file is used to test BBDB file parsing and processing
## functionality in ASynK
##
## Usage is: python test_bb.py <bbdbfile>

import logging, os, shutil, sys, traceback, unittest

## Being able to fix the sys.path thusly makes is easy to execute this
## script standalone from IDLE. Hack it is, but what the hell.
DIR_PATH    = os.path.abspath(os.path.join(
    os.path.dirname(os.path.abspath('__file__')), '../..'))
EXTRA_PATHS = [os.path.join(DIR_PATH, 'lib'), os.path.join(DIR_PATH, 'asynk')]
sys.path = EXTRA_PATHS + sys.path

from state         import Config
from pimdb_bb      import BBPIMDB
from folder_bb     import BBContactsFolder
from contact_bb    import BBContact

conf_fn    = '../../config.json'
state_src  = '../../state.init.json'
state_dest = './state.test.json'

shutil.copyfile(state_src, state_dest)
config = Config(confn=conf_fn, staten=state_dest)

def usage ():
    print 'Usage: python test_bb.py <bbdb db file>'

def main (argv=None):
    global bbfn
    print 'Command line: ', sys.argv

    if len(sys.argv) > 1:
        bbfn = sys.argv[1]
    else:
        usage()
        sys.exit(-1)

    suite = unittest.TestLoader().loadTestsFromTestCase(TestBBDB)
    unittest.TextTestRunner(verbosity=2).run(suite)

class TestBBDB(unittest.TestCase):
    def setUp (self):
        self.config = config
        self.bbdbfn = bbfn

    def test_parse (self):
        self.bb = BBPIMDB(self.config, bbfn)

def rest ():
    tests = TestBBContact(config_fn='../config.json',
                          state_fn='./state.json',
                          bbfn=bbfn)
    if len(sys.argv) > 2:
        name = sys.argv[2]
    else:
        name = 'Amma'

    tests.print_contacts(name=name)
    # tests.write_to_file()

class TestBBContact:
    def __init__ (self, config_fn, state_fn, bbfn):
        logging.debug('Getting started... Reading Config File...')

        self.config = Config(config_fn, state_fn)
        self.bb     = BBPIMDB(self.config, bbfn)
        ms          = self.bb.get_def_msgstore()
        self.deff   = ms.get_folder(ms.get_def_folder_name())

    def print_contacts (self, cnt=0, name=None):
        self.deff.print_contacts(cnt=cnt, name=name)

    def write_to_file (self):
        self.deff.save()

if __name__ == '__main__':
    logging.getLogger().setLevel(logging.DEBUG)
    main()
