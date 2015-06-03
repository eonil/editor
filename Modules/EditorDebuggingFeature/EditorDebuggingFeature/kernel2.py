
#	LLDB remote execution kernel.
#	Intentionally crashes for any errors.

import sys
import lldb
from weakref import WeakValueDictionary


#	This is manual object management.
#	Only objects registered here can be transferred to remote process.
ID_TO_OBJ_MAP	=	WeakValueDictionary()




#	Protocol Summary
#	----------------
#	Processes line-by-line.
#	Single REQUEST must make a single RESPONSE.
#	REQUESTer must wait for a RESPONSE.

#	Object transmission
#	-------------------
#
#	There're two type of objects.
#
#	-	Values. Transmitted by copy. `VALUE:<type>:<expr>`
#	-	Objects. Transmitted by ref. `ID:<number>`


def readCall():


def	writeError(msg):
	print("RESPONSE:ERROR:" + msg)

def	writeOK(tobjexpr):
	print("RESPONSE:OK:" + tobjexpr)



def	decodeValue(x):

def	decodeObject(idnum):
	ID_TO_OBJ_MAP[idnum]


def	decodeTOBJ(x):

def	unregisterObjectForID(id):
	ID_TO_OBJ_MAP[id]	=	None

def	transForID(id):
	ID_TO_OBJ_MAP[id]

def	encodeObjectIntoTransmissionExpression(o):
	if o == None:
		return	"NoneType::"
	
	idnum	=	id(temp)
	if ID_TO_OBJ_MAP[idnum] == None:
		ID_TO_OBJ_MAP[id(o)]	=	o

	return	o.__class__.__name__ + ":" + idnum + ":" + o



def	decodeObjectFromTransmissionExpression(x):
	if x == "NoneType::":
		return	None

	ps			=	x.split(":",2)
	typename	=	ps[0]
	idnum		=	ps[1]
	expr		=	ps[2]
		
	return	ID_TO_OBJ_MAP[int(idnum)]

#	if idnum == "":
#		return	ID_TO_OBJ_MAP[int(idnum)]
#
#	else:
#		return	eval(ps[0])(ps[2])


def	callInstanceMethodFromSwift(self, methodName, argExpressionList):
	temp	=	getattr(self, methodName)(*args)
	idnum	=	id(temp)
	ID_TO_OBJ_MAP[id(temp)]	=	temp
	return	temp.__class__.__name__ + ":" + idnum  + ":" + temp




while True:
	exec(sys.stdin.readline())
	sys.stdout.flush()