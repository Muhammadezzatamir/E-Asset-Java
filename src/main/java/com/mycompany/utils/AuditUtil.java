package com.mycompany.utils;

import java.sql.Timestamp;

public class AuditUtil {

    public static AuditInfo generateCreateAudit(String userId) {
        Timestamp now = new Timestamp(System.currentTimeMillis());
        return new AuditInfo(now, userId, null, null, now, userId, "CIPTA REKOD");
    }

    public static AuditInfo generateUpdateAudit(String userId) {
        Timestamp now = new Timestamp(System.currentTimeMillis());
        return new AuditInfo(null, null, now, userId, now, userId, "PINDA REKOD");
    }

    public static AuditInfo generateDeleteAudit(String userId) {
        Timestamp now = new Timestamp(System.currentTimeMillis());
        return new AuditInfo(null, null, now, userId, now, userId, "PADAM REKOD");
    }

    public static class AuditInfo {
        public final Timestamp addDate;
        public final String addUserId;
        public final Timestamp modDate;
        public final String modUserId;
        public final Timestamp actionDate;
        public final String actionUserId;
        public final String action;

        public AuditInfo(Timestamp addDate, String addUserId,
                         Timestamp modDate, String modUserId,
                         Timestamp actionDate, String actionUserId,
                         String action) {
            this.addDate = addDate;
            this.addUserId = addUserId;
            this.modDate = modDate;
            this.modUserId = modUserId;
            this.actionDate = actionDate;
            this.actionUserId = actionUserId;
            this.action = action;
        }
    }
}
