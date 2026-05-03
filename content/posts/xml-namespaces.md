+++
title = "XML Namespaces"
author = ["Logan Barnett"]
date = 2021-08-23T00:00:00-07:00
aliases = ["/xml-namespaces.html"]
categories = ["xml"]
draft = false
+++

<div class="ox-hugo-toc toc local">

- [XML Namespaces](#xml-namespaces)
    - [The Skinny](#the-skinny)
    - [Depth](#depth)
        - [Namespaces](#namespaces)
        - [Prefixes](#prefixes)
        - [Default Namespaces](#default-namespaces)
        - [Querying an XML Document with Namespaces](#querying-an-xml-document-with-namespaces)

</div>
<!--endtoc-->


## XML Namespaces {#xml-namespaces}

This post covers the importance of namespaces in XML. Anyone doing XML
transformations or data aggregation from these documents needs to be aware of
them.  This document assumes familiarity with XML to at least a minor degree.

I am not claiming this document is complete but it should hopefully serve as a
quick primer for anyone wanting to wrap their heads around XML namespaces.


### The Skinny {#the-skinny}

XML Namespaces, simply put, are just URIs. Full stop.

You can find the spec on namespaces at <https://www.w3.org/TR/xml-names/>.


### Depth {#depth}


#### Namespaces {#namespaces}

URNs can appear which don't look much like <span class="underline">typical</span> URIs, but are URIs
nonetheless.

It might be best to think of the namespaces as arbitrary strings.  The important
takeaway here is that the XML namespace is not the prefix you see in tags and
attributes.  We'll get into that later in this document.


#### Prefixes {#prefixes}

A prefix is an arbitrary identifier used to refer to a namespace.  It is not the
namespace itself.  Document producers can produce perfectly valid documents
without agreeing on what prefixes to use, if any (default namespaces remove the
need for prefixes).

A prefix is established with the `xmlns:[prefix]` attribute, where `[prefix]` is
the name of the prefix.  The namespace is the value given to the attribute.

<a id="code-snippet--xml-namespace-prefix-example-i"></a>
```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<i:IntuitResponse xmlns:i="http://schema.intuit.com/finance/v3"
                time="2016-10-14T10:48:39.109-07:00">
    <i:QueryResponse startPosition="1" maxResults="79" totalCount="79">
    </i:QueryResponse>
</i:IntuitResponse>
```

In this document, the uses `i` as the prefix.  The namespace is
`http://schema.intuit.com/finance/v3`.  For all of these nodes, the namespace is
`http://schema.intuit.com/finance/v3`.

Another document producer could crank this out as well:

<a id="code-snippet--xml-namespace-prefix-exmaple-foo"></a>
```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<foo:IntuitResponse xmlns:foo="http://schema.intuit.com/finance/v3"
                time="2016-10-14T10:48:39.109-07:00">
    <foo:QueryResponse startPosition="1" maxResults="79" totalCount="79">
    </foo:QueryResponse>
</foo:IntuitResponse>
```

These two documents are semantically the same, because the namespaces attached
to the nodes are the same.  Any sort of transformation or aggregation you do
with XML data must account for this, or any variation in the prefix will run you
afoul of XML validators.  Some validators might be less picky in this regard -
probably because the authors of said validators didn't have a firm grasp on
namespaces. The problem with ignoring them is that downstream consumers of the
document will be looking at invalid documents - data will have been removed.

Another peculiar bit about namespace prefixes is that they are applied to the
node which contains the attribute, not just the children.


#### Default Namespaces {#default-namespaces}

A default namespace is essentially an implicit namespace.  It is declared with
the `xmlns` attribute, and like prefixed namespaces, the value is namespace
itself (a URI).

<a id="code-snippet--xml-namespace-default-example"></a>
```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<IntuitResponse xmlns="http://schema.intuit.com/finance/v3"
                time="2016-10-14T10:48:39.109-07:00">
    <QueryResponse startPosition="1" maxResults="79" totalCount="79">
    </QueryResponse>
</IntuitResponse>
```

In this case the `xmlns` attribute declares the default namespace as
`http://schema.intuit.com/finance/v3` and it is applied to the `IntuitResponse`
element as well as `QueryResponse`.  This would descend down the entire document
hierarchy until another default namespace were declared.  The most immediate
parent declaration wins when determining a child's namespace.

It's also noteworthy that this document is semantically the same as those found
in [Prefixes](#prefixes).


#### Querying an XML Document with Namespaces {#querying-an-xml-document-with-namespaces}

I have found that tools that use XPath and even other tools will provide a
mechanism to declare a namespace alias, since queries become unwieldy when the
full namespace is used.  These aliases look an awful lot like prefixes.

Here is what the `nokogiri` Ruby gem looks like when using XPath:

<a id="code-snippet--ruby-nokogiri-xpath-example"></a>
```ruby
puts doc.xpath('/i:IntuitResponse/i:QueryResponse',
                'i' => "http://schema.intuit.com/finance/v3")
```

And this will get the `QueryResponse` contents.

Similarly, here is a C# API:

<a id="code-snippet--csharp-xpath-example"></a>
```csharp
XmlNamespaceManager nsmgr = new XmlNamespaceManager(doc.NameTable);
nsmgr.AddNamespace("i", "http://schema.intuit.com/finance/v3");
XmlNodeList nodes = el.SelectNodes(@"/i:IntuitResponse/i:QueryResponse", nsmgr);
```

Tools such as `oq`, which do not use XPath, have chosen a similar approach:

<a id="code-snippet--oq-query-example"></a>
```shell
oq \
  --xmlns \
  --xml-namespace-alias 'i=http://schema.intuit.com/finance/v3' \
  -i xml \
  -o xml \
  <<< <EOF

EOF
```
