#ifndef DOMXPathExpressionImpl_HEADER_GUARD_
#define DOMXPathExpressionImpl_HEADER_GUARD_

/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <xercesc/util/XMemory.hpp>
#include <xercesc/util/PlatformUtils.hpp>
#include <xercesc/dom/DOMXPathExpression.hpp>

XERCES_CPP_NAMESPACE_BEGIN

class DOMElement;
class XercesXPath;
class XPathMatcher;
class DOMXPathResultImpl;
class DOMXPathNSResolver;
class XMLStringPool;

class CDOM_EXPORT DOMXPathExpressionImpl :  public XMemory,
                                            public DOMXPathExpression
{
public:
    DOMXPathExpressionImpl(const XMLCh *expression, const DOMXPathNSResolver *resolver, MemoryManager* const manager = XMLPlatformUtils::fgMemoryManager);
    virtual ~DOMXPathExpressionImpl();

    virtual void* evaluate(DOMNode *contextNode, unsigned short type, void* result) const;

    virtual void release() const;

protected:
    bool testNode(XPathMatcher* matcher, DOMXPathResultImpl* result, DOMElement *node) const;
    void cleanUp();

    XMLStringPool*              fStringPool;
    XercesXPath*                fParsedExpression;
    XMLCh*                      fExpression;
    bool                        fMoveToRoot;

    MemoryManager* const        fMemoryManager;
};

XERCES_CPP_NAMESPACE_END

#endif
