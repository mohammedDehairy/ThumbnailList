ThumbnailList
=============

its a thumnail like table with multiple columns

Copyright (c) 2012 Mohammed El Dehairy


Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

installation

1.Copy the classes folder into your project.

2.add CoreGraphics.framework to you project.

Use

1.add the thumbnailListView to your viewController .

2.immplement the ThumbnailListDataSourceDelegate.

3.to enter edit mode call -(void)setEnableEdit:(BOOL)value method of the thumbanilListView instance. //OPTIONAL

4.handle cell rearrange in -(void)thumbnailList:(ThumbnailList*) list didSwapCellAtIndex:(int) sourceIndex withCellAtIndex:(int) destinationIndex;

ThumbnailListDataSourceDelegate delegate Method.// OPTIONAL

5.handle deleting cells in -(void)thumbnailList:(ThumbnailList*) list didDeleteCellAtIndex:(int) index; 

ThumbnailListDataSourceDelegate delegate Method. //OPTIONAL

6.handle -(void)thumbnailList:(ThumbnailList *) list didSelectThumbAtIndex:(int)index; // A MUST

7.handle  -(int)numberOfcellsForthumbanilList:(ThumbnailList *) list ; to return total number of cells to view //A MUST

8.handle -(ThumbnailCell*)thumbnailList:(ThumbnailList*) list cellForIndex:(int)index; to return the ThumbnailCell instance
for each object in your data source // A MUST

