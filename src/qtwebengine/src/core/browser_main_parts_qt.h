/****************************************************************************
**
** Copyright (C) 2018 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the QtWebEngine module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl-3.0.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 2.0 or (at your option) the GNU General
** Public license version 3 or any later version approved by the KDE Free
** Qt Foundation. The licenses are as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL2 and LICENSE.GPL3
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-2.0.html and
** https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

#ifndef BROWSER_MAIN_PARTS_QT_H
#define BROWSER_MAIN_PARTS_QT_H

#include "content/public/browser/browser_main_parts.h"

namespace base {
class MessagePump;
}

namespace content {
class ServiceManagerConnection;
}

namespace resource_coordinator {
class ProcessResourceCoordinator;
}

namespace QtWebEngineCore {

std::unique_ptr<base::MessagePump> messagePumpFactory();

class BrowserMainPartsQt : public content::BrowserMainParts
{
public:
    BrowserMainPartsQt();
    ~BrowserMainPartsQt();

    int PreEarlyInitialization() override;
    void PreMainMessageLoopStart() override;
    void PreMainMessageLoopRun() override;
    void PostMainMessageLoopRun() override;
    int PreCreateThreads() override;
    void ServiceManagerConnectionStarted(content::ServiceManagerConnection *connection) override;

private:
    DISALLOW_COPY_AND_ASSIGN(BrowserMainPartsQt);
    std::unique_ptr<resource_coordinator::ProcessResourceCoordinator> m_processResourceCoordinator;
};

} // namespace QtWebEngineCore

#endif // BROWSER_MAIN_PARTS_QT_H
