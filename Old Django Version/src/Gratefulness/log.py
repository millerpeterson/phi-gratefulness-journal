import logging
import logging.config

LOGGING_CONFIG_FILE = 'logging.conf'
DEFAULT_LOG_NAME = 'gratefulness'

# Ensure that the logging config is only loaded once.
if not hasattr(logging, 'configDone'):
    logging.configDone = False
    
def setupLogging():
    logging.config.fileConfig(LOGGING_CONFIG_FILE)    
    logging.configDone = True    

setupLogging()

logger = logging.getLogger(DEFAULT_LOG_NAME)

def debug(msg):
    logger.debug(msg)
    
def info(msg):
    logger.info(msg)
    
def warn(msg):
    logger.warn(msg)
    
def error(msg):
    logger.error(msg)
    
def critical(msg):
    logger.critical(msg)