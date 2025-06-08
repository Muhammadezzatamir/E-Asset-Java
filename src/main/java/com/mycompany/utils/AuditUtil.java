package com.mycompany.utils;

import java.sql.Timestamp;

public class AuditUtil {

    public static AuditInfo generateCreateAudit(int userId) {
        Timestamp now = new Timestamp(System.currentTimeMillis());
        return new AuditInfo(now, userId, null, 0, now, userId, "CIPTA REKOD");
    }

    public static AuditInfo generateUpdateAudit(int userId) {
        Timestamp now = new Timestamp(System.currentTimeMillis());
        return new AuditInfo(null, 0, now, userId, now, userId, "PINDA REKOD");
    }

    public static AuditInfo generateDeleteAudit(int userId) {
        Timestamp now = new Timestamp(System.currentTimeMillis());
        return new AuditInfo(null, 0, now, userId, now, userId, "PADAM REKOD");
    }

    public static class AuditInfo {
        public final Timestamp addDate;
        public final int addUserId;
        public final Timestamp modDate;
        public final int modUserId;
        public final Timestamp actionDate;
        public final int actionUserId;
        public final String action;

        public AuditInfo(Timestamp addDate, int addUserId,
                         Timestamp modDate, int modUserId,
                         Timestamp actionDate, int actionUserId,
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
